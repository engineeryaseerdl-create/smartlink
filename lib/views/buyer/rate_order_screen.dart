import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../models/rating_model.dart';
import '../../services/rating_service.dart';
import '../../utils/constants.dart';

class RateOrderScreen extends StatefulWidget {
  final OrderModel order;

  const RateOrderScreen({super.key, required this.order});

  @override
  State<RateOrderScreen> createState() => _RateOrderScreenState();
}

class _RateOrderScreenState extends State<RateOrderScreen> {
  int _sellerRating = 0;
  int _riderRating = 0;
  final _sellerCommentController = TextEditingController();
  final _riderCommentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _sellerCommentController.dispose();
    _riderCommentController.dispose();
    super.dispose();
  }

  Future<void> _submitRatings() async {
    if (_sellerRating == 0 && _riderRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please rate at least one party')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (_sellerRating > 0) {
        await RatingService.submitRating(
          orderId: widget.order.id,
          revieweeId: widget.order.sellerId,
          revieweeType: 'seller',
          rating: _sellerRating,
          comment: _sellerCommentController.text.trim(),
        );
      }

      if (_riderRating > 0 && widget.order.riderId != null) {
        await RatingService.submitRating(
          orderId: widget.order.id,
          revieweeId: widget.order.riderId!,
          revieweeType: 'rider',
          rating: _riderRating,
          comment: _riderCommentController.text.trim(),
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
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
        title: const Text('Rate Order'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingSection(
              title: 'Rate Seller',
              subtitle: widget.order.sellerName,
              rating: _sellerRating,
              onRatingChanged: (rating) => setState(() => _sellerRating = rating),
              commentController: _sellerCommentController,
            ),
            const SizedBox(height: AppSpacing.xl),
            if (widget.order.riderId != null)
              _buildRatingSection(
                title: 'Rate Rider',
                subtitle: widget.order.riderName ?? 'Rider',
                rating: _riderRating,
                onRatingChanged: (rating) => setState(() => _riderRating = rating),
                commentController: _riderCommentController,
              ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRatings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
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
                    : const Text('Submit Ratings', style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection({
    required String title,
    required String subtitle,
    required int rating,
    required Function(int) onRatingChanged,
    required TextEditingController commentController,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading3),
          Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey)),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () => onRatingChanged(index + 1),
                icon: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: AppColors.gold,
                  size: 40,
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add a comment (optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                borderSide: const BorderSide(color: AppColors.primaryGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
