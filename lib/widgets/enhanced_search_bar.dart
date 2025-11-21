import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/product_model.dart';

class EnhancedSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final Function(ProductCategory?) onCategoryFilter;
  final Function(double, double) onPriceFilter;

  const EnhancedSearchBar({
    super.key,
    required this.onSearch,
    required this.onCategoryFilter,
    required this.onPriceFilter,
  });

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _recentSearches = [];
  bool _showSuggestions = false;

  final List<String> _suggestions = [
    'iPhone',
    'Samsung Galaxy',
    'Rice',
    'Beans',
    'Laptop',
    'Headphones',
    'Shoes',
    'Dress',
    'Toyota',
    'Honda',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToRecentSearches(String query) {
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        onCategoryFilter: widget.onCategoryFilter,
        onPriceFilter: widget.onPriceFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              setState(() {
                _showSuggestions = value.isNotEmpty;
              });
              widget.onSearch(value);
            },
            onSubmitted: (value) {
              _addToRecentSearches(value);
              setState(() {
                _showSuggestions = false;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search for products, brands, categories...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        widget.onSearch('');
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                    ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: _showFilterBottomSheet,
                      icon: const Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
        if (_showSuggestions) _buildSuggestions(),
      ],
    );
  }

  Widget _buildSuggestions() {
    final filteredSuggestions = _suggestions
        .where((s) => s.toLowerCase().contains(_controller.text.toLowerCase()))
        .take(5)
        .toList();

    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(
                'Recent Searches',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ..._recentSearches.map((search) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.history, size: 18),
                  title: Text(search),
                  onTap: () {
                    _controller.text = search;
                    widget.onSearch(search);
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                )),
            if (filteredSuggestions.isNotEmpty) const Divider(),
          ],
          if (filteredSuggestions.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(
                'Suggestions',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...filteredSuggestions.map((suggestion) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.search, size: 18),
                  title: Text(suggestion),
                  onTap: () {
                    _controller.text = suggestion;
                    widget.onSearch(suggestion);
                    _addToRecentSearches(suggestion);
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                )),
          ],
        ],
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final Function(ProductCategory?) onCategoryFilter;
  final Function(double, double) onPriceFilter;

  const FilterBottomSheet({
    super.key,
    required this.onCategoryFilter,
    required this.onPriceFilter,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  ProductCategory? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 100000);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Products',
                  style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Category',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  children: ProductCategory.values.map((category) {
                    final isSelected = _selectedCategory == category;
                    return FilterChip(
                      label: Text(category.toString().split('.').last),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : null;
                        });
                      },
                      selectedColor: AppColors.primaryGreen.withOpacity(0.2),
                      checkmarkColor: AppColors.primaryGreen,
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Price Range (₦${_priceRange.start.round()} - ₦${_priceRange.end.round()})',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 100000,
                  divisions: 100,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = null;
                            _priceRange = const RangeValues(0, 100000);
                          });
                          widget.onCategoryFilter(null);
                          widget.onPriceFilter(0, 100000);
                          Navigator.pop(context);
                        },
                        child: const Text('Clear'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onCategoryFilter(_selectedCategory);
                          widget.onPriceFilter(_priceRange.start, _priceRange.end);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                        ),
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
