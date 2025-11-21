import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RatingDisplayWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;
  final bool showCount;

  const RatingDisplayWidget({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.size = 16,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor()
                ? Icons.star
                : index < rating
                    ? Icons.star_half
                    : Icons.star_border,
            color: AppColors.gold,
            size: size,
          );
        }),
        if (showCount) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class RatingInputWidget extends StatefulWidget {
  final Function(double) onRatingChanged;
  final double initialRating;
  final double size;

  const RatingInputWidget({
    super.key,
    required this.onRatingChanged,
    this.initialRating = 0,
    this.size = 32,
  });

  @override
  State<RatingInputWidget> createState() => _RatingInputWidgetState();
}

class _RatingInputWidgetState extends State<RatingInputWidget> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1.0;
            });
            widget.onRatingChanged(_rating);
          },
          child: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: AppColors.gold,
            size: widget.size,
          ),
        );
      }),
    );
  }
}

class ReviewFormWidget extends StatefulWidget {
  final String productId;
  final String orderId;
  final Function(Map<String, dynamic>) onSubmit;

  const ReviewFormWidget({
    super.key,
    required this.productId,
    required this.orderId,
    required this.onSubmit,
  });

  @override
  State<ReviewFormWidget> createState() => _ReviewFormWidgetState();
}

class _ReviewFormWidgetState extends State<ReviewFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  double _rating = 0;
  final List<String> _images = [];
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Write a Review', style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.lg),
            
            // Rating Input
            const Text('Rating', style: AppTextStyles.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            RatingInputWidget(
              onRatingChanged: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Comment Input
            TextFormField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                hintText: 'Share your experience with this product...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 10) {
                  return 'Review must be at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Image Upload (placeholder)
            const Text('Photos (Optional)', style: AppTextStyles.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 32),
                    Text('Add Photos'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rating > 0 && !_isSubmitting ? _submitReview : null,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReview() {
    if (_formKey.currentState!.validate() && _rating > 0) {
      setState(() {
        _isSubmitting = true;
      });
      
      widget.onSubmit({
        'productId': widget.productId,
        'orderId': widget.orderId,
        'rating': _rating,
        'comment': _commentController.text.trim(),
        'images': _images,
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
