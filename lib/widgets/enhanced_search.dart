import 'package:flutter/material.dart';
import '../utils/constants.dart';

class EnhancedSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback? onVoiceSearch;

  const EnhancedSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onVoiceSearch,
  });

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar> {
  final List<String> _suggestions = [
    'Rice', 'Beans', 'iPhone', 'Samsung', 'Laptop', 'Shoes', 'Dress', 'Car'
  ];
  
  bool _showSuggestions = false;

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
            controller: widget.controller,
            onChanged: (value) {
              widget.onChanged(value);
              setState(() {
                _showSuggestions = value.isNotEmpty;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search products, brands...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.onVoiceSearch != null)
                    IconButton(
                      onPressed: widget.onVoiceSearch,
                      icon: const Icon(Icons.mic, color: AppColors.primaryGreen),
                    ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () => _showFilterSheet(context),
                      icon: const Icon(Icons.tune, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                borderSide: BorderSide.none,
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
        .where((s) => s.toLowerCase().contains(widget.controller.text.toLowerCase()))
        .take(4)
        .toList();

    if (filteredSuggestions.isEmpty) return const SizedBox();

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
        children: filteredSuggestions.map((suggestion) {
          return ListTile(
            dense: true,
            leading: const Icon(Icons.search, size: 16, color: AppColors.textSecondary),
            title: Text(suggestion, style: AppTextStyles.bodyMedium),
            onTap: () {
              widget.controller.text = suggestion;
              widget.onChanged(suggestion);
              setState(() => _showSuggestions = false);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const FilterBottomSheet(),
    );
  }
}

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Filter Products', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.lg),
          _buildFilterOption('Price Range', Icons.attach_money),
          _buildFilterOption('Rating', Icons.star),
          _buildFilterOption('Distance', Icons.location_on),
          _buildFilterOption('Category', Icons.category),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}