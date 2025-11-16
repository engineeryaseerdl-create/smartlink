import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadService {
  static const String baseUrl = 'http://localhost:5000/api';

  Future<List<String>> uploadImages(List<File> images) async {
    try {
      final formData = FormData();
      
      for (var image in images) {
        final fileName = image.path.split('/').last;
        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(
            image.path,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        ));
      }

      final dio = Dio();
      dio.options.baseUrl = baseUrl;
      
      final token = await _getToken();
      if (token != null) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await dio.post('/upload/multiple', data: formData);
      
      if (response.data['success']) {
        final fileUrls = List<String>.from(response.data['fileUrls']);
        return fileUrls.map((url) => 'http://localhost:5000$url').toList();
      }
      
      throw Exception('Upload failed');
    } catch (e) {
      throw Exception('Error uploading images: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
