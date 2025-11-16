import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SearchFilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  final Map<String, dynamic> initialFilters;

  const SearchFilterWidget({
    super.key,
    required this.onFiltersChanged,
    this.initialFilters = const {},
  });

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 1000000);
  double _minRating = 0;
  String _sortBy = 'relevance';

  final List<String> _categories = [
    'electronics', 'fashion', 'food', 'home', 'books', 'sports', 'beauty', 'automotive'
  ];

  final List<Map<String, String>> _sortOptions = [
    {'value': 'relevance', 'label': 'Relevance'},
    {'value': 'price_low', 'label': 'Price: Low to High'},
    {'value': 'price_high', 'label': 'Price: High to Low'},
    {'value': 'rating', 'label': 'Highest Rated'},
    {'value': 'newest', 'label': 'Newest First'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  void _initializeFilters() {
    _searchController.text = widget.initialFilters['q'] ?? '';
    _selectedCategory = widget.initialFilters['category'];
    _minRating = widget.initialFilters['rating']?.toDouble() ?? 0;
    _sortBy = widget.initialFilters['sortBy'] ?? 'relevance';
  }

  void _applyFilters() {
    final filters = <String, dynamic>{
      'q': _searchController.text.trim(),
      if (_selectedCategory != null) 'category': _selectedCategory,
      'minPrice': _priceRange.start.round(),
      'maxPrice': _priceRange.end.round(),
      if (_minRating > 0) 'rating': _minRating,
      'sortBy': _sortBy,
    };
    widget.onFiltersChanged(filters);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => _showFilterBottomSheet(context),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (_) => _applyFilters(),
          ),
        ),
        
        // Category Chips
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: _categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: _selectedCategory == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = null;
                      });
                      _applyFilters();
                    },
                  ),
                );
              }
              
              final category = _categories[index - 1];
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: FilterChip(
                  label: Text(category.toUpperCase()),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : null;
                    });
                    _applyFilters();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: AppTextStyles.heading2),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                        _priceRange = const RangeValues(0, 1000000);
                        _minRating = 0;
                        _sortBy = 'relevance';
                      });
                      setModalState(() {});
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Price Range
              Text('Price Range', style: AppTextStyles.bodyLarge),
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 1000000,
                divisions: 100,
                labels: RangeLabels(
                  '₦${_priceRange.start.round()}',
                  '₦${_priceRange.end.round()}',
                ),
                onChanged: (values) {
                  setModalState(() {
                    _priceRange = values;
                  });
                },
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Rating Filter
              Text('Minimum Rating', style: AppTextStyles.bodyLarge),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setModalState(() {
                        _minRating = index + 1.0;
                      });
                    },
                    icon: Icon(
                      index < _minRating ? Icons.star : Icons.star_border,
                      color: AppColors.gold,
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Sort Options
              Text('Sort By', style: AppTextStyles.bodyLarge),
              ...._sortOptions.map((option) => RadioListTile<String>(
                title: Text(option['label']!),
                value: option['value']!,
                groupValue: _sortBy,
                onChanged: (value) {
                  setModalState(() {
                    _sortBy = value!;
                  });
                },
              )),
              
              const Spacer(),
              
              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}