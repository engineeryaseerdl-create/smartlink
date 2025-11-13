import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  /// Pick multiple images from gallery (simplified version)
  static Future<List<File>> pickMultipleImages({
    int maxImages = 5,
    int imageQuality = 85,
  }) async {
    try {
      // Pick one image at a time since pickMultipleImages might not be available
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        return [File(pickedFile.path)];
      }
      return [];
    } catch (e) {
      throw Exception('Failed to pick images: $e');
    }
  }

  /// Pick single image from gallery
  static Future<File?> pickImageFromGallery({
    int imageQuality = 85,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  /// Take picture with camera
  static Future<File?> pickImageFromCamera({
    int imageQuality = 85,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      throw Exception('Failed to take picture: $e');
    }
  }
}