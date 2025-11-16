import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/analytics_widget.dart';
import '../../utils/constants.dart';

class SellerAnalyticsScreen extends StatefulWidget {
  const SellerAnalyticsScreen({super.key});

  @override
  State<SellerAnalyticsScreen> createState() => _SellerAnalyticsScreenState();
}

class _SellerAnalyticsScreenState extends State<SellerAnalyticsScreen> {
  String _selectedPeriod = '30';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AnalyticsProvider>().loadSellerAnalytics(_selectedPeriod);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (period) {
              setState(() {
                _selectedPeriod = period;
              });
              context.read<AnalyticsProvider>().loadSellerAnalytics(period);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '7', child: Text('Last 7 days')),
              const PopupMenuItem(value: '30', child: Text('Last 30 days')),
              const PopupMenuItem(value: '90', child: Text('Last 90 days')),
            ],
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.date_range),
            ),
          ),
        ],
      ),
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final analytics = provider.sellerAnalytics;
          if (analytics == null) {
            return const Center(child: Text('No analytics data available'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadSellerAnalytics(_selectedPeriod),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.2,
                    children: [
                      AnalyticsCardWidget(
                        title: 'Total Revenue',
                        value: '₦${analytics['summary']['totalRevenue'] ?? 0}',
                        icon: Icons.attach_money,
                        color: AppColors.primaryGreen,
                      ),
                      AnalyticsCardWidget(
                        title: 'Total Orders',
                        value: '${analytics['summary']['totalOrders'] ?? 0}',
                        icon: Icons.shopping_bag,
                        color: Colors.blue,
                      ),
                      AnalyticsCardWidget(
                        title: 'Average Order',
                        value: analytics['summary']['totalOrders'] > 0
                            ? '₦${(analytics['summary']['totalRevenue'] / analytics['summary']['totalOrders']).toStringAsFixed(0)}'
                            : '₦0',
                        icon: Icons.trending_up,
                        color: Colors.orange,
                      ),
                      AnalyticsCardWidget(
                        title: 'Products Sold',
                        value: '${analytics['topProducts']?.length ?? 0}',
                        icon: Icons.inventory,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Sales Chart
                  if (analytics['salesByDay'] != null && analytics['salesByDay'].isNotEmpty)
                    SalesChartWidget(
                      salesData: List<Map<String, dynamic>>.from(analytics['salesByDay']),
                      title: 'Sales Trend (Last $_selectedPeriod days)',
                    ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Top Products
                  if (analytics['topProducts'] != null && analytics['topProducts'].isNotEmpty)
                    TopProductsWidget(
                      topProducts: List<Map<String, dynamic>>.from(analytics['topProducts']),
                    ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Order Status Chart
                  if (analytics['orderStatus'] != null && analytics['orderStatus'].isNotEmpty)
                    OrderStatusChartWidget(
                      orderStatus: List<Map<String, dynamic>>.from(analytics['orderStatus']),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}