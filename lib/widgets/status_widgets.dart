import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Status indicator with progress and animations
class StatusIndicator extends StatelessWidget {
  final OrderStatus status;
  final double? progress;
  final bool showProgress;
  final bool animated;

  const StatusIndicator({
    super.key,
    required this.status,
    this.progress,
    this.showProgress = true,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        border: Border.all(
          color: status.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (animated)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    status.icon,
                    size: 14,
                    color: status.textColor,
                  ),
                );
              },
            )
          else
            Icon(
              status.icon,
              size: 14,
              color: status.textColor,
            ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            status.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: status.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Order status enum with visual properties
enum OrderStatus {
  pending(
    'Pending',
    Icons.schedule,
    AppColors.warningOrange,
    Color(0xFFFFF3E0),
    Color(0xFFFFB74D),
  ),
  confirmed(
    'Confirmed',
    Icons.check_circle_outline,
    AppColors.infoBlue,
    Color(0xFFE3F2FD),
    Color(0xFF42A5F5),
  ),
  preparing(
    'Preparing',
    Icons.restaurant,
    AppColors.mutedGreen,
    Color(0xFFE8F5E8),
    Color(0xFF66BB6A),
  ),
  ready(
    'Ready',
    Icons.done_all,
    AppColors.primaryGreen,
    Color(0xFFE8F5E8),
    AppColors.primaryGreen,
  ),
  dispatched(
    'Dispatched',
    Icons.local_shipping,
    AppColors.infoBlue,
    Color(0xFFE3F2FD),
    AppColors.infoBlue,
  ),
  delivered(
    'Delivered',
    Icons.check_circle,
    AppColors.successGreen,
    Color(0xFFE8F5E8),
    AppColors.successGreen,
  ),
  cancelled(
    'Cancelled',
    Icons.cancel,
    AppColors.errorRed,
    Color(0xFFFFEBEE),
    AppColors.errorRed,
  );

  const OrderStatus(
    this.label,
    this.icon,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
  );

  final String label;
  final IconData icon;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
}

/// Animated progress bar with status
class StatusProgressBar extends StatefulWidget {
  final List<ProgressStep> steps;
  final int currentStep;
  final bool showLabels;
  final Color? activeColor;
  final Color? inactiveColor;

  const StatusProgressBar({
    super.key,
    required this.steps,
    required this.currentStep,
    this.showLabels = true,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<StatusProgressBar> createState() => _StatusProgressBarState();
}

class _StatusProgressBarState extends State<StatusProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _updateAnimation();
    _progressController.forward();
  }

  void _updateAnimation() {
    final progress = widget.currentStep / (widget.steps.length - 1);
    _progressAnimation = Tween<double>(
      begin: 0,
      end: progress,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(StatusProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _updateAnimation();
      _progressController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress indicators
        Row(
          children: List.generate(widget.steps.length * 2 - 1, (index) {
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              final step = widget.steps[stepIndex];
              final isActive = stepIndex <= widget.currentStep;
              final isCurrent = stepIndex == widget.currentStep;

              return AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isActive
                          ? (widget.activeColor ?? AppColors.primaryGreen)
                          : (widget.inactiveColor ?? Colors.grey[300]),
                      shape: BoxShape.circle,
                      boxShadow: isCurrent ? [
                        BoxShadow(
                          color: (widget.activeColor ?? AppColors.primaryGreen)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ] : null,
                    ),
                    child: Center(
                      child: stepIndex < widget.currentStep
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : Icon(
                              step.icon,
                              color: isActive ? Colors.white : Colors.grey[600],
                              size: 16,
                            ),
                    ),
                  );
                },
              );
            } else {
              // Progress line
              final stepIndex = (index - 1) ~/ 2;
              final isActive = stepIndex < widget.currentStep;

              return Expanded(
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? (widget.activeColor ?? AppColors.primaryGreen)
                            : (widget.inactiveColor ?? Colors.grey[300]),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    );
                  },
                ),
              );
            }
          }),
        ),

        if (widget.showLabels) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isActive = index <= widget.currentStep;

              return Expanded(
                child: Text(
                  step.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isActive
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

/// Progress step model
class ProgressStep {
  final String label;
  final IconData icon;
  final String? description;
  final DateTime? timestamp;

  const ProgressStep({
    required this.label,
    required this.icon,
    this.description,
    this.timestamp,
  });
}

/// Delivery tracking widget
class DeliveryTrackingWidget extends StatelessWidget {
  final List<TrackingEvent> events;
  final String? estimatedDelivery;

  const DeliveryTrackingWidget({
    super.key,
    required this.events,
    this.estimatedDelivery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_shipping,
                color: AppColors.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('Delivery Tracking', style: AppTextStyles.heading4),
            ],
          ),

          if (estimatedDelivery != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    color: AppColors.primaryGreen,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Estimated delivery: $estimatedDelivery',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),

          ...events.asMap().entries.map((entry) {
            final index = entry.key;
            final event = entry.value;
            final isLast = index == events.length - 1;
            final isCompleted = event.isCompleted;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.primaryGreen
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            )
                          : null,
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 40,
                        color: isCompleted
                            ? AppColors.primaryGreen
                            : Colors.grey[300],
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                          color: isCompleted ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                      ),
                      if (event.description != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          event.description!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      if (event.timestamp != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _formatTimestamp(event.timestamp!),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      if (!isLast) const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

/// Tracking event model
class TrackingEvent {
  final String title;
  final String? description;
  final DateTime? timestamp;
  final bool isCompleted;

  const TrackingEvent({
    required this.title,
    this.description,
    this.timestamp,
    this.isCompleted = false,
  });
}

/// Connection status indicator
class ConnectionStatusIndicator extends StatefulWidget {
  final bool isConnected;
  final VoidCallback? onRetry;

  const ConnectionStatusIndicator({
    super.key,
    required this.isConnected,
    this.onRetry,
  });

  @override
  State<ConnectionStatusIndicator> createState() => _ConnectionStatusIndicatorState();
}

class _ConnectionStatusIndicatorState extends State<ConnectionStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (!widget.isConnected) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ConnectionStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isConnected != widget.isConnected) {
      if (!widget.isConnected) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isConnected) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.errorRed,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'No connection',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.onRetry != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: widget.onRetry,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                      ),
                      child: Text(
                        'Retry',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Battery status indicator for delivery riders
class BatteryStatusIndicator extends StatelessWidget {
  final double batteryLevel; // 0.0 to 1.0
  final bool isCharging;

  const BatteryStatusIndicator({
    super.key,
    required this.batteryLevel,
    this.isCharging = false,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (batteryLevel * 100).round();
    final color = _getBatteryColor();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 12,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            children: [
              Expanded(
                flex: (batteryLevel * 10).round(),
                child: Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              Expanded(
                flex: 10 - (batteryLevel * 10).round(),
                child: const SizedBox(),
              ),
            ],
          ),
        ),
        Container(
          width: 2,
          height: 6,
          margin: const EdgeInsets.only(left: 1),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(1),
              bottomRight: Radius.circular(1),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        if (isCharging)
          const Icon(
            Icons.flash_on,
            color: AppColors.warningOrange,
            size: 12,
          ),
        Text(
          '$percentage%',
          style: AppTextStyles.bodySmall.copyWith(color: color),
        ),
      ],
    );
  }

  Color _getBatteryColor() {
    if (batteryLevel > 0.5) return AppColors.successGreen;
    if (batteryLevel > 0.2) return AppColors.warningOrange;
    return AppColors.errorRed;
  }
}