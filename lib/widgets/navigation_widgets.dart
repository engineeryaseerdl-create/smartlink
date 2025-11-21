import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Breadcrumb navigation widget
class BreadcrumbNavigation extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final Color? activeColor;
  final Color? inactiveColor;
  final IconData separatorIcon;

  const BreadcrumbNavigation({
    super.key,
    required this.items,
    this.activeColor,
    this.inactiveColor,
    this.separatorIcon = Icons.chevron_right,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: _buildBreadcrumbs(),
      ),
    );
  }

  List<Widget> _buildBreadcrumbs() {
    final widgets = <Widget>[];
    
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;
      final isActive = item.isActive || isLast;

      // Add breadcrumb item
      widgets.add(
        GestureDetector(
          onTap: item.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isActive 
                  ? (activeColor ?? AppColors.primaryGreen).withOpacity(0.1)
                  : null,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 16,
                    color: isActive 
                        ? (activeColor ?? AppColors.primaryGreen)
                        : (inactiveColor ?? AppColors.textSecondary),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  item.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isActive 
                        ? (activeColor ?? AppColors.primaryGreen)
                        : (inactiveColor ?? AppColors.textSecondary),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Add separator
      if (!isLast) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Icon(
              separatorIcon,
              size: 16,
              color: inactiveColor ?? AppColors.textSecondary,
            ),
          ),
        );
      }
    }

    return widgets;
  }
}

/// Breadcrumb item model
class BreadcrumbItem {
  final String title;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isActive;

  const BreadcrumbItem({
    required this.title,
    this.icon,
    this.onTap,
    this.isActive = false,
  });
}

/// Quick action floating button
class QuickActionButton extends StatefulWidget {
  final List<QuickAction> actions;
  final IconData mainIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? heroTag;

  const QuickActionButton({
    super.key,
    required this.actions,
    this.mainIcon = Icons.add,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
  });

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _buttonAnimation;
  late Animation<double> _rotateAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.75).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(widget.actions.length, (index) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  (index / widget.actions.length) * 0.5,
                  1.0,
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isExpanded)
                    Container(
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: Text(
                        widget.actions[index].label,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                      ),
                    ),
                  FloatingActionButton(
                    mini: true,
                    heroTag: '${widget.heroTag}_$index',
                    backgroundColor: widget.actions[index].backgroundColor,
                    onPressed: () {
                      _toggleExpanded();
                      widget.actions[index].onPressed();
                    },
                    child: Icon(
                      widget.actions[index].icon,
                      color: widget.actions[index].foregroundColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).reversed,
        FloatingActionButton(
          heroTag: widget.heroTag ?? 'main_fab',
          backgroundColor: widget.backgroundColor ?? AppColors.primaryGreen,
          onPressed: _toggleExpanded,
          child: AnimatedBuilder(
            animation: _rotateAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotateAnimation.value * 2 * 3.14159,
                child: Icon(
                  _isExpanded ? Icons.close : widget.mainIcon,
                  color: widget.foregroundColor ?? Colors.white,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Quick action model
class QuickAction {
  final String label;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback onPressed;

  const QuickAction({
    required this.label,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
    required this.onPressed,
  });
}

/// Tab bar with smooth indicator animation
class AnimatedTabBar extends StatefulWidget {
  final List<TabItem> tabs;
  final int currentIndex;
  final Function(int) onTabSelected;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? indicatorColor;

  const AnimatedTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
  });

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _indicatorAnimation = Tween<double>(
      begin: widget.currentIndex.toDouble(),
      end: widget.currentIndex.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(AnimatedTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _indicatorAnimation = Tween<double>(
        begin: oldWidget.currentIndex.toDouble(),
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth = screenWidth / widget.tabs.length;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated indicator
          AnimatedBuilder(
            animation: _indicatorAnimation,
            builder: (context, child) {
              return Positioned(
                top: 0,
                left: _indicatorAnimation.value * tabWidth,
                child: Container(
                  width: tabWidth,
                  height: 3,
                  decoration: BoxDecoration(
                    color: widget.indicatorColor ?? AppColors.primaryGreen,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(1.5),
                      bottomRight: Radius.circular(1.5),
                    ),
                  ),
                ),
              );
            },
          ),
          // Tab buttons
          Row(
            children: List.generate(widget.tabs.length, (index) {
              final tab = widget.tabs[index];
              final isActive = index == widget.currentIndex;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () => widget.onTabSelected(index),
                  child: SizedBox(
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isActive ? tab.activeIcon : tab.icon,
                          color: isActive 
                              ? (widget.activeColor ?? AppColors.primaryGreen)
                              : (widget.inactiveColor ?? AppColors.textSecondary),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.label,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isActive 
                                ? (widget.activeColor ?? AppColors.primaryGreen)
                                : (widget.inactiveColor ?? AppColors.textSecondary),
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Tab item model
class TabItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String? badgeText;

  const TabItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.badgeText,
  });
}

/// Stepper navigation for multi-step processes
class StepperNavigation extends StatelessWidget {
  final List<StepItem> steps;
  final int currentStep;
  final Function(int)? onStepTapped;

  const StepperNavigation({
    super.key,
    required this.steps,
    required this.currentStep,
    this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            final step = steps[stepIndex];
            final isActive = stepIndex == currentStep;
            final isCompleted = stepIndex < currentStep;
            final isClickable = onStepTapped != null && 
                (isCompleted || stepIndex <= currentStep + 1);

            return GestureDetector(
              onTap: isClickable ? () => onStepTapped!(stepIndex) : null,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? AppColors.successGreen
                      : isActive 
                          ? AppColors.primaryGreen
                          : Colors.grey[300],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? AppColors.primaryGreen : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : Text(
                          '${stepIndex + 1}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isActive || isCompleted ? Colors.white : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            );
          } else {
            // Connector line
            final stepIndex = (index - 1) ~/ 2;
            final isCompleted = stepIndex < currentStep;
            
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.successGreen : Colors.grey[300],
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

/// Step item model
class StepItem {
  final String title;
  final String? description;
  final bool isOptional;

  const StepItem({
    required this.title,
    this.description,
    this.isOptional = false,
  });
}
