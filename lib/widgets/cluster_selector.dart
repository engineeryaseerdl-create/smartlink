import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order_model.dart';
import '../models/rider_cluster_model.dart';
import '../providers/cluster_provider.dart';
import '../providers/order_provider.dart';
import '../utils/constants.dart';

class ClusterSelector extends StatefulWidget {
  final OrderModel order;

  const ClusterSelector({super.key, required this.order});

  @override
  State<ClusterSelector> createState() => _ClusterSelectorState();
}

class _ClusterSelectorState extends State<ClusterSelector> {
  @override
  void initState() {
    super.initState();
    context.read<ClusterProvider>().loadClusters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.groups, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              const Text('Select Rider Cluster', style: AppTextStyles.heading3),
              const Spacer(),
              IconButton(
                onPressed: () => context.read<ClusterProvider>().loadClusters(),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<ClusterProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final clusters = provider.getClustersForLocation(widget.order.sellerLocation);
              
              if (clusters.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
                        SizedBox(height: 16),
                        Text('No clusters found in this area'),
                        SizedBox(height: 8),
                        Text('Try refreshing or contact support'),
                      ],
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: clusters.length,
                  itemBuilder: (context, index) {
                    final cluster = clusters[index];
                    return _buildClusterCard(cluster);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClusterCard(RiderCluster cluster) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.groups, color: AppColors.primaryGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cluster.name, style: AppTextStyles.heading4),
                      Text(cluster.location, style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      )),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: cluster.isOnline ? AppColors.successGreen : AppColors.errorRed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    cluster.isOnline ? 'Online' : 'Offline',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('Leader: ${cluster.leaderName}'),
                const SizedBox(width: 16),
                const Icon(Icons.people, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${cluster.members.length} riders'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: AppColors.gold),
                const SizedBox(width: 4),
                Text('${cluster.rating}'),
                const SizedBox(width: 16),
                const Icon(Icons.delivery_dining, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${cluster.totalDeliveries} deliveries'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: AppColors.primaryGreen),
                const SizedBox(width: 4),
                Text(
                  cluster.leaderPhone,
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _callClusterLeader(cluster),
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Call Leader'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _assignToCluster(cluster),
                    icon: const Icon(Icons.assignment, size: 18),
                    label: const Text('Assign Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _callClusterLeader(RiderCluster cluster) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call ${cluster.leaderName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cluster: ${cluster.name}'),
            Text('Phone: ${cluster.leaderPhone}'),
            if (cluster.backupPhone != null)
              Text('Backup: ${cluster.backupPhone}'),
            const SizedBox(height: 8),
            const Text('Call to discuss delivery details and negotiate price.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _launchPhone(cluster.leaderPhone);
            },
            icon: const Icon(Icons.phone),
            label: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _assignToCluster(RiderCluster cluster) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign to Cluster'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Assign this order to ${cluster.name}?'),
            const SizedBox(height: 8),
            const Text('The cluster leader will assign a specific rider and the buyer will receive rider contact details.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                // Assign to cluster leader for now
                final leader = cluster.members.firstWhere((m) => m.isLeader);
                await context.read<OrderProvider>().assignRider(widget.order.id, leader.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order assigned to ${cluster.name}. Buyer will receive rider details.'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to assign order: $e'),
                    backgroundColor: AppColors.errorRed,
                  ),
                );
              }
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  void _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}