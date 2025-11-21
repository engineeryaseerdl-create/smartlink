import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuickActionFAB extends StatefulWidget {
  final List<QuickAction> actions;
  final Widget icon;
  final Color? backgroundColor;

  const QuickActionFAB({
    super.key,
    required this.actions,
    required this.icon,
    this.backgroundColor,
  });

  @override
  State<QuickActionFAB> createState() => _QuickActionFABState();
}

class _QuickActionFABState extends State<QuickActionFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    HapticFeedback.lightImpact();
    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ..._buildActionButtons(),
        FloatingActionButton(
          heroTag: "main_fab",
          onPressed: _toggle,
          backgroundColor: widget.backgroundColor,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0,
            duration: const Duration(milliseconds: 300),
            child: widget.icon,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActionButtons() {
    return widget.actions.asMap().entries.map((entry) {
      final index = entry.key;
      final action = entry.value;
      
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final offset = (index + 1) * 70.0 * _animation.value;
          return Transform.translate(
            offset: Offset(0, -offset),
            child: Opacity(
              opacity: _animation.value,
              child: FloatingActionButton.small(
                heroTag: "fab_$index",
                onPressed: () {
                  _toggle();
                  action.onPressed();
                },
                backgroundColor: action.backgroundColor,
                child: action.icon,
              ),
            ),
          );
        },
      );
    }).toList();
  }
}

class QuickAction {
  final Widget icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const QuickAction({
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
  });
}
