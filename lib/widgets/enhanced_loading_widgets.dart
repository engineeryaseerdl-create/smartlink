import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/constants.dart';

/// Enhanced shimmer widget with customizable properties
class EnhancedShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;

  const EnhancedShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDark ? Colors.grey[800]! : Colors.grey[300]!),
      highlightColor: highlightColor ?? (isDark ? Colors.grey[700]! : Colors.grey[100]!),
      period: period ?? const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

/// Skeleton container with rounded corners
class SkeletonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  const SkeletonContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(AppBorderRadius.sm),
      ),
    );
  }
}

/// Enhanced product card skeleton with better animations
class EnhancedProductCardSkeleton extends StatelessWidget {
  final bool showPrice;
  final bool showRating;

  const EnhancedProductCardSkeleton({
    super.key,
    this.showPrice = true,
    this.showRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedShimmer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image skeleton
            const SkeletonContainer(
              height: 160,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppBorderRadius.lg),
                topRight: Radius.circular(AppBorderRadius.lg),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const SkeletonContainer(height: 16, width: double.infinity),
                  const SizedBox(height: AppSpacing.xs),
                  // Subtitle
                  const SkeletonContainer(height: 14, width: 120),
                  const SizedBox(height: AppSpacing.sm),
                  // Rating if enabled
                  if (showRating) ...[
                    Row(
                      children: [
                        for (int i = 0; i < 5; i++) ...[
                          const SkeletonContainer(width: 12, height: 12),
                          if (i < 4) const SizedBox(width: 2),
                        ],
                        const SizedBox(width: AppSpacing.xs),
                        const SkeletonContainer(width: 30, height: 12),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  // Price
                  if (showPrice)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SkeletonContainer(height: 18, width: 80),
                        SkeletonContainer(
                          width: 32,
                          height: 32,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Order card skeleton with status indicator
class OrderCardSkeleton extends StatelessWidget {
  const OrderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return EnhancedShimmer(
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SkeletonContainer(height: 16, width: 100),
                SkeletonContainer(
                  height: 24,
                  width: 80,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const SkeletonContainer(height: 14, width: 150),
            const SizedBox(height: AppSpacing.xs),
            const SkeletonContainer(height: 14, width: 120),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SkeletonContainer(height: 18, width: 80),
                Row(
                  children: [
                    SkeletonContainer(
                      width: 24,
                      height: 24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const SkeletonContainer(height: 14, width: 60),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Chat message skeleton
class ChatMessageSkeleton extends StatelessWidget {
  final bool isMe;

  const ChatMessageSkeleton({super.key, this.isMe = false});

  @override
  Widget build(BuildContext context) {
    return EnhancedShimmer(
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          padding: const EdgeInsets.all(AppSpacing.sm),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonContainer(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.4,
              ),
              const SizedBox(height: AppSpacing.xs),
              const SkeletonContainer(height: 14, width: 80),
            ],
          ),
        ),
      ),
    );
  }
}

/// Search results skeleton
class SearchResultsSkeleton extends StatelessWidget {
  final int itemCount;

  const SearchResultsSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => EnhancedShimmer(
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Row(
              children: [
                const SkeletonContainer(width: 50, height: 50),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonContainer(height: 16, width: double.infinity),
                      const SizedBox(height: AppSpacing.xs),
                      const SkeletonContainer(height: 14, width: 100),
                      const SizedBox(height: AppSpacing.xs),
                      SkeletonContainer(
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pulse loading animation for buttons
class PulseLoadingButton extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final VoidCallback? onPressed;

  const PulseLoadingButton({
    super.key,
    required this.child,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  State<PulseLoadingButton> createState() => _PulseLoadingButtonState();
}

class _PulseLoadingButtonState extends State<PulseLoadingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(PulseLoadingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _controller.repeat(reverse: true);
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isLoading ? _scaleAnimation.value : 1.0,
          child: widget.child,
        );
      },
    );
  }
}

/// Wave loading animation
class WaveLoadingIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const WaveLoadingIndicator({
    super.key,
    this.color = AppColors.primaryGreen,
    this.size = 40,
  });

  @override
  State<WaveLoadingIndicator> createState() => _WaveLoadingIndicatorState();
}

class _WaveLoadingIndicatorState extends State<WaveLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.2, 1.0, curve: Curves.ease),
        ),
      );
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: widget.size / 6,
              height: widget.size / 6 + (_animations[index].value * widget.size / 3),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.6 + (_animations[index].value * 0.4)),
                borderRadius: BorderRadius.circular(widget.size / 12),
              ),
            );
          },
        );
      }),
    );
  }
}