import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../services/rating_service.dart';
import '../../utils/constants.dart';

class DisputeOrderScreen extends StatefulWidget {
  final OrderModel order;

  const DisputeOrderScreen({super.key, required this.order});

  @override
  State<DisputeOrderScreen> createState() => _DisputeOrderScreenState();
}

class _DisputeOrderScreenState extends State<DisputeOrderScreen> {
  String _selectedType = 'delayed';
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _disputeTypes = [
    {'value': 'delayed', 'label': 'Delayed Delivery', 'icon': Icons.access_time},
    {'value': 'failed', 'label': 'Failed Delivery', 'icon': Icons.cancel},
    {'value': 'damaged', 'label': 'Damaged Product', 'icon': Icons.broken_image},
    {'value': 'wrong_item', 'label': 'Wrong Item', 'icon': Icons.swap_horiz},
    {'value': 'other', 'label': 'Other Issue', 'icon': Icons.report_problem},
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitDispute() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe the issue')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await RatingService.submitDispute(
        orderId: widget.order.id,
        disputeType: _selectedType,
        description: _descriptionController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dispute submitted successfully'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${widget.order.trackingCode ?? widget.order.id.substring(0, 8)}',
                style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.sm),
            Text('Select the type of issue:', style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            ..._disputeTypes.map((type) => _buildDisputeTypeCard(type)),
            const SizedBox(height: AppSpacing.lg),
            Text('Describe the issue:', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Please provide details about the issue...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  borderSide: const BorderSide(color: AppColors.primaryGreen),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitDispute,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorRed,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Submit Dispute', style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisputeTypeCard(Map<String, dynamic> type) {
    final isSelected = _selectedType == type['value'];
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type['value']),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen.withOpacity(0.1) : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.lightGrey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Row(
          children: [
            Icon(
              type['icon'],
              color: isSelected ? AppColors.primaryGreen : AppColors.grey,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              type['label'],
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primaryGreen : AppColors.darkGrey,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryGreen),
          ],
        ),
      ),
    );
  }
}
