import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'custom_button.dart';
import 'animated_widgets.dart';

/// Enhanced error widget with animations and better UX
class EnhancedErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onGoBack;
  final IconData? icon;
  final Color? color;
  final String? retryButtonText;

  const EnhancedErrorStateWidget({
    super.key,
    this.title = 'Oops! Something went wrong',
    required this.message,
    this.onRetry,
    this.onGoBack,
    this.icon,
    this.color,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final errorColor = color ?? AppColors.errorRed;
    
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated error icon
            SlideInAnimation(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: errorColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.error_outline,
                  size: 80,
                  color: errorColor,
                ),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Title with shake animation on appear
            ShakeAnimation(
              child: Text(
                title,
                style: AppTextStyles.heading3.copyWith(color: errorColor),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Message with fade in
            FadeInAnimation(
              delay: const Duration(milliseconds: 300),
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Action buttons with slide up animation
            SlideInAnimation(
              direction: SlideDirection.bottom,
              delay: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  if (onRetry != null)
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: retryButtonText ?? 'Try Again',
                        onPressed: onRetry!,
                        icon: Icons.refresh,
                        backgroundColor: errorColor,
                      ),
                    ),
                  
                  if (onGoBack != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: onGoBack,
                        child: Text(
                          'Go Back',
                          style: AppTextStyles.buttonText.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Network error with specific messaging
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onGoOffline;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
    this.onGoOffline,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedErrorStateWidget(
      icon: Icons.wifi_off,
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again. Some features may be available offline.',
      onRetry: onRetry,
      onGoBack: onGoOffline,
      color: AppColors.warningOrange,
    );
  }
}

/// Server error widget
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onContactSupport;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
    this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedErrorStateWidget(
      icon: Icons.cloud_off,
      title: 'Server Temporarily Unavailable',
      message: 'Our servers are currently experiencing issues. Please try again in a few moments.',
      onRetry: onRetry,
      onGoBack: onContactSupport,
      retryButtonText: 'Retry',
    );
  }
}

/// Enhanced inline error with slide animation
class EnhancedInlineErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionText;

  const EnhancedInlineErrorWidget({
    super.key,
    required this.message,
    this.onDismiss,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return SlideInAnimation(
      direction: SlideDirection.top,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.errorRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(
            color: AppColors.errorRed.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.errorRed,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.errorRed,
                    ),
                  ),
                  if (onAction != null && actionText != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    GestureDetector(
                      onTap: onAction,
                      child: Text(
                        actionText!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.errorRed,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onDismiss != null)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onDismiss,
                color: AppColors.errorRed,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}

/// Enhanced success notification with animation
class EnhancedSuccessWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onAction;
  final String? actionText;
  final VoidCallback? onDismiss;

  const EnhancedSuccessWidget({
    super.key,
    required this.message,
    this.onAction,
    this.actionText,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return SlideInAnimation(
      direction: SlideDirection.top,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.successGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(
            color: AppColors.successGreen.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.successGreen,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.successGreen,
                    ),
                  ),
                  if (onAction != null && actionText != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    GestureDetector(
                      onTap: onAction,
                      child: Text(
                        actionText!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.successGreen,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onDismiss != null)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onDismiss,
                color: AppColors.successGreen,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}

/// Toast-like floating notification
class FloatingNotification {
  static void showSuccess(BuildContext context, String message, {VoidCallback? onAction, String? actionText}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 16,
        right: 16,
        child: SlideInAnimation(
          direction: SlideDirection.top,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.successGreen,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      message,
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ),
                  if (onAction != null && actionText != null)
                    TextButton(
                      onPressed: () {
                        entry.remove();
                        onAction();
                      },
                      child: Text(
                        actionText,
                        style: AppTextStyles.buttonText.copyWith(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    
    // Auto remove after delay
    Future.delayed(const Duration(seconds: 3), () {
      entry.remove();
    });
  }

  static void showError(BuildContext context, String message, {VoidCallback? onRetry}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 16,
        right: 16,
        child: SlideInAnimation(
          direction: SlideDirection.top,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorRed,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      message,
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ),
                  if (onRetry != null)
                    TextButton(
                      onPressed: () {
                        entry.remove();
                        onRetry();
                      },
                      child: Text(
                        'Retry',
                        style: AppTextStyles.buttonText.copyWith(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    
    // Auto remove after delay
    Future.delayed(const Duration(seconds: 4), () {
      entry.remove();
    });
  }
}
