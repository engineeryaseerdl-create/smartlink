import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/animated_widgets.dart';
import '../../widgets/responsive_wrapper.dart';
import '../../widgets/error_modal.dart';
import '../../services/image_picker_service.dart';
import '../../services/upload_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  ProductCategory _selectedCategory = ProductCategory.electronics;
  List<File> _selectedImages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_selectedImages.length >= 10) {
      ErrorModal.show(context, 'Maximum 10 images allowed');
      return;
    }
    
    final List<File> images = await ImagePickerService.pickMultipleImages(
      maxImages: 10 - _selectedImages.length,
      imageQuality: 85,
    );
    
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _takePicture() async {
    if (_selectedImages.length >= 10) {
      ErrorModal.show(context, 'Maximum 10 images allowed');
      return;
    }
    
    final File? image = await ImagePickerService.pickImageFromCamera(
      imageQuality: 85,
    );
    
    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _handleAddProduct() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedImages.isEmpty) {
      ErrorModal.show(context, 'Please add at least one product image');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser!;

      // Upload images to server
      final uploadService = UploadService();
      final imageUrls = await uploadService.uploadImages(_selectedImages);

      final product = ProductModel(
        id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        category: _selectedCategory,
        sellerId: user.id,
        sellerName: user.name,
        sellerLocation: user.location ?? '',
        images: imageUrls,
        stockQuantity: int.parse(_stockController.text),
        createdAt: DateTime.now(),
      );

      await context.read<ProductProvider>().addProduct(product);
      
      if (!mounted) return;
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ErrorModal.show(context, 'Error adding product: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.headerGradientStart,
                AppColors.headerGradientEnd,
              ],
            ),
          ),
        ),
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: ResponsiveContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: ResponsiveUtils.getResponsivePagePadding(context).left,
              right: ResponsiveUtils.getResponsivePagePadding(context).right,
              top: ResponsiveUtils.getResponsivePagePadding(context).top,
              bottom: MediaQuery.of(context).viewInsets.bottom + ResponsiveUtils.getResponsivePagePadding(context).bottom,
            ),
            child: FadeInWidget(
              slideUp: true,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Image Upload Section
              Text('Product Images',
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? AppColors.darkCard 
                      : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  border: Border.all(
                    color: _selectedImages.isEmpty 
                        ? Colors.grey.withOpacity(0.3)
                        : AppColors.primaryGreen.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    if (_selectedImages.isEmpty) ...[
                      Icon(
                        Icons.add_a_photo,
                        size: 48,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Add product images',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _pickImages,
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Gallery'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _takePicture,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.infoBlue,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selectedImages.length}/10 images',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          if (_selectedImages.length < 10)
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: _pickImages,
                                  icon: const Icon(Icons.add_photo_alternate, size: 18),
                                  label: const Text('Add'),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: AppSpacing.sm),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                    child: Image.file(
                                      _selectedImages[index],
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
                                          color: AppColors.errorRed,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: AppColors.white,
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
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Product Title',
                hint: 'Enter product title',
                controller: _titleController,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Description',
                hint: 'Enter product description',
                controller: _descriptionController,
                maxLines: 4,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Price (₦)',
                hint: 'Enter price',
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Stock Quantity',
                hint: 'Enter quantity',
                controller: _stockController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Category',
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<ProductCategory>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: ProductCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: _isLoading ? 'Adding Product...' : 'Add Product',
                onPressed: _isLoading ? null : () => _handleAddProduct(),
                width: double.infinity,
              ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
