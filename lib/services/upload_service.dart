import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class UploadService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<String> uploadProfilePicture(File imageFile) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/upload/single'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final jsonData = json.decode(responseData);

    if (response.statusCode == 200) {
      return jsonData['fileUrl'];
    } else {
      throw Exception(jsonData['message'] ?? 'Upload failed');
    }
  }

  Future<String> uploadSingleImage(File imageFile) async {
    return await uploadProfilePicture(imageFile);
  }

  Future<List<String>> uploadImages(List<File> imageFiles) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/upload/multiple'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    
    for (var file in imageFiles) {
      request.files.add(await http.MultipartFile.fromPath('images', file.path));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final jsonData = json.decode(responseData);

    if (response.statusCode == 200) {
      return List<String>.from(jsonData['fileUrls']);
    } else {
      throw Exception(jsonData['message'] ?? 'Upload failed');
    }
  }
}
