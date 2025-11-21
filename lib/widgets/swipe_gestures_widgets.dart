import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Swipe to delete widget
class SwipeToDeleteWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;
  final String deleteText;
  final Color deleteColor;
  final IconData deleteIcon;

  const SwipeToDeleteWidget({
    super.key,
    required this.child,
    required this.onDelete,
    this.onEdit,
    this.deleteText = 'Delete',
    this.deleteColor = AppColors.errorRed,
    this.deleteIcon = Icons.delete,
  });

  @override
  State<SwipeToDeleteWidget> createState() => _SwipeToDeleteWidgetState();
}

class _SwipeToDeleteWidgetState extends State<SwipeToDeleteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startDeleteAnimation() async {
    await _controller.forward();
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 - _animation.value,
          child: Opacity(
            opacity: 1 - _animation.value,
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  // Show confirmation dialog
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text('Are you sure you want to delete this item?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.errorRed,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ) ?? false;
                }
                return false;
              },
              onDismissed: (direction) {
                _startDeleteAnimation();
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: widget.deleteColor,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.deleteIcon,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.deleteText,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

/// Pull to refresh wrapper
class PullToRefreshWrapper extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final String refreshText;

  const PullToRefreshWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
    this.refreshText = 'Pull to refresh',
  });

  @override
  State<PullToRefreshWrapper> createState() => _PullToRefreshWrapperState();
}

class _PullToRefreshWrapperState extends State<PullToRefreshWrapper> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = 
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: widget.onRefresh,
      color: AppColors.primaryGreen,
      backgroundColor: Colors.white,
      strokeWidth: 3,
      child: widget.child,
    );
  }

  // Method to programmatically trigger refresh
  Future<void> triggerRefresh() async {
    await _refreshIndicatorKey.currentState?.show();
  }
}

/// Swipe actions widget (like iOS mail app)
class SwipeActionsWidget extends StatefulWidget {
  final Widget child;
  final List<SwipeAction> startActions;
  final List<SwipeAction> endActions;

  const SwipeActionsWidget({
    super.key,
    required this.child,
    this.startActions = const [],
    this.endActions = const [],
  });

  @override
  State<SwipeActionsWidget> createState() => _SwipeActionsWidgetState();
}

class _SwipeActionsWidgetState extends State<SwipeActionsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  double _dragExtent = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.3, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _isDragging = true;
    _controller.stop();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    final delta = details.primaryDelta ?? 0;
    _dragExtent += delta;

    final normalizedDragExtent = _dragExtent / context.size!.width;
    _controller.value = normalizedDragExtent.abs().clamp(0.0, 1.0);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    _isDragging = false;

    final velocity = details.velocity.pixelsPerSecond.dx;
    const threshold = 0.2;

    if (_controller.value > threshold || velocity.abs() > 1000) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    _dragExtent = 0;
  }

  Widget _buildActions(List<SwipeAction> actions, bool isStart) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions.map((action) => GestureDetector(
        onTap: () {
          _controller.reverse();
          action.onPressed();
        },
        child: Container(
          width: 80,
          color: action.backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, color: action.foregroundColor, size: 24),
              const SizedBox(height: 4),
              Text(
                action.label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: action.foregroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        children: [
          // Background actions
          Positioned.fill(
            child: Row(
              children: [
                if (widget.startActions.isNotEmpty)
                  _buildActions(widget.startActions, true),
                const Spacer(),
                if (widget.endActions.isNotEmpty)
                  _buildActions(widget.endActions, false),
              ],
            ),
          ),
          // Main content
          SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// Swipe action model
class SwipeAction {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  const SwipeAction({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
    required this.onPressed,
  });
}

/// Horizontal scroll picker (like iOS date picker)
class HorizontalScrollPicker extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final Function(String) onItemSelected;
  final double itemHeight;
  final TextStyle? itemStyle;
  final TextStyle? selectedItemStyle;

  const HorizontalScrollPicker({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onItemSelected,
    this.itemHeight = 60,
    this.itemStyle,
    this.selectedItemStyle,
  });

  @override
  State<HorizontalScrollPicker> createState() => _HorizontalScrollPickerState();
}

class _HorizontalScrollPickerState extends State<HorizontalScrollPicker> {
  late ScrollController _scrollController;
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedItem != null 
        ? widget.items.indexOf(widget.selectedItem!) 
        : 0;
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.3,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.itemHeight,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
          widget.onItemSelected(widget.items[index]);
        },
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final isSelected = index == _currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.primaryGreen.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: isSelected 
                  ? Border.all(color: AppColors.primaryGreen)
                  : null,
            ),
            child: Center(
              child: Text(
                widget.items[index],
                style: isSelected
                    ? (widget.selectedItemStyle ?? AppTextStyles.heading4.copyWith(
                        color: AppColors.primaryGreen,
                      ))
                    : (widget.itemStyle ?? AppTextStyles.bodyLarge),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
