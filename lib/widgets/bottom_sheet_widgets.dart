import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'custom_button.dart';

/// Enhanced bottom sheet with smooth animations
class EnhancedBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppBorderRadius.xl),
            topRight: Radius.circular(AppBorderRadius.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

/// Quick add to cart bottom sheet
class AddToCartBottomSheet extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int maxQuantity;
  final VoidCallback onAddToCart;

  const AddToCartBottomSheet({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.maxQuantity,
    required this.onAddToCart,
  });

  @override
  State<AddToCartBottomSheet> createState() => _AddToCartBottomSheetState();
}

class _AddToCartBottomSheetState extends State<AddToCartBottomSheet> {
  int quantity = 1;
  String? selectedSize;
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product info
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: AppTextStyles.heading4,
                        maxLines: 2,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '₦${widget.price.toStringAsFixed(2)}',
                        style: AppTextStyles.heading4.copyWith(
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Options section
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quantity selector
                const Text('Quantity', style: AppTextStyles.heading5),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    IconButton(
                      onPressed: quantity > 1
                          ? () => setState(() => quantity--)
                          : null,
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Text(
                        quantity.toString(),
                        style: AppTextStyles.heading4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: quantity < widget.maxQuantity
                          ? () => setState(() => quantity++)
                          : null,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Stock: ${widget.maxQuantity}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Size selection
                const Text('Size', style: AppTextStyles.heading5),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: ['S', 'M', 'L', 'XL'].map((size) {
                    final isSelected = selectedSize == size;
                    return GestureDetector(
                      onTap: () => setState(() => selectedSize = size),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryGreen
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryGreen
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          size,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Add to Cart - ₦${(widget.price * quantity).toStringAsFixed(2)}',
                    onPressed: () {
                      widget.onAddToCart();
                      Navigator.of(context).pop();
                    },
                    icon: Icons.shopping_cart_outlined,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Filter bottom sheet
class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> filters;
  RangeValues priceRange = const RangeValues(0, 10000);

  @override
  void initState() {
    super.initState();
    filters = Map.from(widget.currentFilters);
    priceRange = RangeValues(
      filters['minPrice']?.toDouble() ?? 0,
      filters['maxPrice']?.toDouble() ?? 10000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters', style: AppTextStyles.heading3),
              TextButton(
                onPressed: () {
                  setState(() {
                    filters.clear();
                    priceRange = const RangeValues(0, 10000);
                  });
                },
                child: const Text('Clear All'),
              ),
            ],
          ),

          const Divider(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price range
                  const Text('Price Range', style: AppTextStyles.heading4),
                  const SizedBox(height: AppSpacing.sm),
                  RangeSlider(
                    values: priceRange,
                    min: 0,
                    max: 50000,
                    divisions: 100,
                    activeColor: AppColors.primaryGreen,
                    labels: RangeLabels(
                      '₦${priceRange.start.round()}',
                      '₦${priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setState(() => priceRange = values);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₦${priceRange.start.round()}'),
                      Text('₦${priceRange.end.round()}'),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Category
                  const Text('Category', style: AppTextStyles.heading4),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: ['Electronics', 'Fashion', 'Home', 'Books'].map((category) {
                      final isSelected = filters['categories']?.contains(category) ?? false;
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            filters['categories'] ??= <String>[];
                            if (selected) {
                              filters['categories'].add(category);
                            } else {
                              filters['categories'].remove(category);
                            }
                          });
                        },
                        selectedColor: AppColors.primaryGreen.withOpacity(0.2),
                        checkmarkColor: AppColors.primaryGreen,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Rating
                  const Text('Minimum Rating', style: AppTextStyles.heading4),
                  const SizedBox(height: AppSpacing.sm),
                  Column(
                    children: [4, 3, 2, 1].map((rating) {
                      return CheckboxListTile(
                        title: Row(
                          children: [
                            ...List.generate(5, (index) => Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: AppColors.gold,
                              size: 16,
                            )),
                            const Text(' & up'),
                          ],
                        ),
                        value: filters['minRating'] == rating,
                        onChanged: (value) {
                          setState(() {
                            filters['minRating'] = value == true ? rating : null;
                          });
                        },
                        activeColor: AppColors.primaryGreen,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Apply button
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: 'Apply Filters',
                  onPressed: () {
                    filters['minPrice'] = priceRange.start;
                    filters['maxPrice'] = priceRange.end;
                    widget.onApplyFilters(filters);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Sort options bottom sheet
class SortBottomSheet extends StatelessWidget {
  final String? currentSort;
  final Function(String) onSortSelected;

  const SortBottomSheet({
    super.key,
    this.currentSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {'value': 'newest', 'label': 'Newest First', 'icon': Icons.new_releases},
      {'value': 'price_low', 'label': 'Price: Low to High', 'icon': Icons.arrow_upward},
      {'value': 'price_high', 'label': 'Price: High to Low', 'icon': Icons.arrow_downward},
      {'value': 'rating', 'label': 'Highest Rated', 'icon': Icons.star},
      {'value': 'popular', 'label': 'Most Popular', 'icon': Icons.trending_up},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Text('Sort by', style: AppTextStyles.heading3),
        ),
        const Divider(),
        ...sortOptions.map((option) => ListTile(
          leading: Icon(
            option['icon'] as IconData,
            color: currentSort == option['value']
                ? AppColors.primaryGreen
                : AppColors.textSecondary,
          ),
          title: Text(
            option['label'] as String,
            style: AppTextStyles.bodyLarge.copyWith(
              color: currentSort == option['value']
                  ? AppColors.primaryGreen
                  : AppColors.textPrimary,
              fontWeight: currentSort == option['value']
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          trailing: currentSort == option['value']
              ? const Icon(Icons.check, color: AppColors.primaryGreen)
              : null,
          onTap: () {
            onSortSelected(option['value'] as String);
            Navigator.of(context).pop();
          },
        )),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}