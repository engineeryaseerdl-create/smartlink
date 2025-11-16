import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class QuickFilters extends StatelessWidget {
  const QuickFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              FilterChip(
                label: const Text('Price: Low to High'),
                selected: provider.sortBy == 'price_asc',
                onSelected: (selected) {
                  provider.setSortBy(selected ? 'price_asc' : null);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Price: High to Low'),
                selected: provider.sortBy == 'price_desc',
                onSelected: (selected) {
                  provider.setSortBy(selected ? 'price_desc' : null);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Highest Rated'),
                selected: provider.sortBy == 'rating',
                onSelected: (selected) {
                  provider.setSortBy(selected ? 'rating' : null);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Newest'),
                selected: provider.sortBy == 'newest',
                onSelected: (selected) {
                  provider.setSortBy(selected ? 'newest' : null);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Free Delivery'),
                selected: provider.freeDeliveryOnly,
                onSelected: (selected) {
                  provider.setFreeDeliveryFilter(selected);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}