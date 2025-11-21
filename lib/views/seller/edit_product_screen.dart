import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/error_modal.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _customCategoryController;
  late ProductCategory _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _stockController = TextEditingController(text: widget.product.stockQuantity.toString());
    _customCategoryController = TextEditingController();
    _selectedCategory = widget.product.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == ProductCategory.others && _customCategoryController.text.trim().isEmpty) {
      ErrorModal.show(context, 'Please specify the category');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedProduct = ProductModel(
        id: widget.product.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        category: _selectedCategory,
        sellerId: widget.product.sellerId,
        sellerName: widget.product.sellerName,
        sellerLocation: widget.product.sellerLocation,
        images: widget.product.images,
        stockQuantity: int.parse(_stockController.text),
        rating: widget.product.rating,
        reviewCount: widget.product.reviewCount,
        createdAt: widget.product.createdAt,
      );

      await context.read<ProductProvider>().updateProduct(updatedProduct);

      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully!'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ErrorModal.show(context, 'Error updating product: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Product Title',
                hint: 'Enter product title',
                controller: _titleController,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Description',
                hint: 'Enter product description',
                controller: _descriptionController,
                maxLines: 4,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Price (₦)',
                hint: 'Enter price',
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Stock Quantity',
                hint: 'Enter quantity',
                controller: _stockController,
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Category', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<ProductCategory>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: ProductCategory.values.map((category) {
                  String label = category.toString().split('.').last;
                  return DropdownMenuItem(
                    value: category,
                    child: Text(label[0].toUpperCase() + label.substring(1)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              if (_selectedCategory == ProductCategory.others) ...[
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  label: 'Specify Category',
                  hint: 'Enter custom category',
                  controller: _customCategoryController,
                  validator: (value) => value?.isEmpty ?? true ? 'Please specify category' : null,
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: _isLoading ? 'Updating...' : 'Update Product',
                onPressed: _isLoading ? null : _handleUpdateProduct,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
