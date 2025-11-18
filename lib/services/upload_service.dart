import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class UploadService {
  static const String baseUrl = 'https://smartlink-backend-2-v3mb.onrender.com/api';

  Future<List<String>> uploadImages(List<File> images) async {
    try {
      final token = await _getToken();
      debugPrint('Upload token: ${token != null ? 'Present' : 'Missing'}');
      
      if (token == null) {
        debugPrint('No auth token found, using local paths');
        return images.map((image) => image.path).toList();
      }

      final formData = FormData();
      
      for (var image in images) {
        final fileName = path.basename(image.path);
        final extension = path.extension(fileName).toLowerCase();
        debugPrint('Uploading file: $fileName, extension: $extension');
        
        MediaType contentType;
        switch (extension) {
          case '.png':
            contentType = MediaType('image', 'png');
            break;
          case '.jpg':
          case '.jpeg':
            contentType = MediaType('image', 'jpeg');
            break;
          case '.gif':
            contentType = MediaType('image', 'gif');
            break;
          case '.webp':
            contentType = MediaType('image', 'webp');
            break;
          default:
            contentType = MediaType('image', 'jpeg');
        }
        
        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(
            image.path,
            filename: fileName,
            contentType: contentType,
          ),
        ));
      }

      final dio = Dio();
      dio.options.baseUrl = baseUrl;
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      dio.options.headers['Authorization'] = 'Bearer $token';

      debugPrint('Making upload request to: $baseUrl/upload/multiple');
      final response = await dio.post('/upload/multiple', data: formData);
      
      if (response.data['success']) {
        final fileUrls = List<String>.from(response.data['fileUrls']);
        debugPrint('Upload successful: $fileUrls');
        return fileUrls.map((url) => url.startsWith('http') ? url : '$baseUrl$url').toList();
      }
      
      throw Exception('Upload failed: ${response.data['message'] ?? 'Unknown error'}');
    } catch (e) {
      debugPrint('Upload error details: $e');
      if (e is DioException) {
        debugPrint('Response data: ${e.response?.data}');
        debugPrint('Status code: ${e.response?.statusCode}');
      }
      // Return local paths as fallback to prevent app crash
      debugPrint('Falling back to local paths');
      return images.map((image) => image.path).toList();
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String> uploadSingleImage(File image) async {
    final urls = await uploadImages([image]);
    return urls.first;
  }
}
