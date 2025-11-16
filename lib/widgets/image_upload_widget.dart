import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';

class ImageUploadWidget extends StatefulWidget {
  final List<String> initialImages;
  final Function(List<String>) onImagesChanged;
  final int maxImages;
  final bool allowMultiple;

  const ImageUploadWidget({
    super.key,
    this.initialImages = const [],
    required this.onImagesChanged,
    this.maxImages = 5,
    this.allowMultiple = true,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  List<String> _images = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.initialImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Grid
        if (_images.isNotEmpty)
          Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _images[index].startsWith('http')
                            ? Image.network(
                                _images[index],
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_images[index]),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        // Upload Button
        if (_images.length < widget.maxImages)
          GestureDetector(
            onTap: _isUploading ? null : _showImageSourceDialog,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.borderLight,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.backgroundLight,
              ),
              child: _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 32,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          widget.allowMultiple
                              ? 'Add Photos (${_images.length}/${widget.maxImages})'
                              : 'Add Photo',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
      ],
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isUploading = true;
      });

      if (widget.allowMultiple && source == ImageSource.gallery) {
        final List<XFile> images = await _picker.pickMultipleImages();
        if (images.isNotEmpty) {
          final remainingSlots = widget.maxImages - _images.length;
          final imagesToAdd = images.take(remainingSlots).toList();
          
          for (final image in imagesToAdd) {
            // In a real app, you would upload to your server here
            // For now, we'll just add the local path
            _images.add(image.path);
          }
          
          widget.onImagesChanged(_images);
        }
      } else {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          // In a real app, you would upload to your server here
          // For now, we'll just add the local path
          if (widget.allowMultiple) {
            _images.add(image.path);
          } else {
            _images = [image.path];
          }
          widget.onImagesChanged(_images);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesChanged(_images);
  }
}

class SingleImageUploadWidget extends StatefulWidget {
  final String? initialImage;
  final Function(String?) onImageChanged;
  final double size;

  const SingleImageUploadWidget({
    super.key,
    this.initialImage,
    required this.onImageChanged,
    this.size = 120,
  });

  @override
  State<SingleImageUploadWidget> createState() => _SingleImageUploadWidgetState();
}

class _SingleImageUploadWidgetState extends State<SingleImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  String? _image;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _image = widget.initialImage;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isUploading ? null : _showImageSourceDialog,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.backgroundLight,
        ),
        child: _isUploading
            ? const Center(child: CircularProgressIndicator())
            : _image != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _image!.startsWith('http')
                            ? Image.network(
                                _image!,
                                width: widget.size,
                                height: widget.size,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_image!),
                                width: widget.size,
                                height: widget.size,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _image = null;
                            });
                            widget.onImageChanged(null);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, size: 32),
                      SizedBox(height: 4),
                      Text('Add Photo'),
                    ],
                  ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isUploading = true;
      });

      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        // In a real app, you would upload to your server here
        setState(() {
          _image = image.path;
        });
        widget.onImageChanged(_image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}