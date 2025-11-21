import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/comparison_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class ComparisonButton extends StatelessWidget {
  final ProductModel product;

  const ComparisonButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<ComparisonProvider>(
      builder: (context, comparison, child) {
        final isInComparison = comparison.isInComparison(product.id);
        return SizedBox(
          width: 32,
          height: 32,
          child: FloatingActionButton(
            heroTag: "compare_${product.id}",
            mini: true,
            onPressed: () {
              if (isInComparison) {
                comparison.removeProduct(product.id);
              } else {
                comparison.addProduct(product);
              }
            },
            backgroundColor: isInComparison ? AppColors.primaryGreen : Colors.grey[300],
            child: Icon(
              Icons.compare_arrows,
              color: isInComparison ? Colors.white : Colors.grey[600],
              size: 16,
            ),
          ),
        );
      },
    );
  }
}

class ComparisonSheet extends StatelessWidget {
  const ComparisonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ComparisonProvider>(
      builder: (context, comparison, child) {
        final products = comparison.products;
        
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Compare Products', style: AppTextStyles.heading2),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (products.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No products to compare'),
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Feature')),
                        DataColumn(label: Text('Product 1')),
                        DataColumn(label: Text('Product 2')),
                      ],
                      rows: [
                        DataRow(cells: [
                          const DataCell(Text('Name')),
                          DataCell(Text(products[0].title)),
                          DataCell(Text(products.length > 1 ? products[1].title : '-')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Price')),
                          DataCell(Text(Helpers.formatCurrency(products[0].price))),
                          DataCell(Text(products.length > 1 ? Helpers.formatCurrency(products[1].price) : '-')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Rating')),
                          DataCell(Text('${products[0].rating} ⭐')),
                          DataCell(Text(products.length > 1 ? '${products[1].rating} ⭐' : '-')),
                        ]),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
