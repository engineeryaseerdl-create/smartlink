import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Success animation with confetti effect
class SuccessAnimationWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onComplete;
  final Duration duration;
  final bool showConfetti;

  const SuccessAnimationWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.onComplete,
    this.duration = const Duration(seconds: 3),
    this.showConfetti = true,
  });

  @override
  State<SuccessAnimationWidget> createState() => _SuccessAnimationWidgetState();
}

class _SuccessAnimationWidgetState extends State<SuccessAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  
  late Animation<double> _checkAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeIn),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await _scaleController.forward();
    await _checkController.forward();
    
    if (widget.showConfetti) {
      _confettiController.forward();
    }

    Future.delayed(widget.duration, () {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success icon with animation
          AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _checkAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.successGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.successGreen.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: CheckmarkPainter(_checkAnimation.value),
                    size: const Size(120, 120),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          // Title and subtitle with fade animation
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.successGreen,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.subtitle!,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),

          // Confetti overlay
          if (widget.showConfetti)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _confettiController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ConfettiPainter(_confettiController.value),
                      size: Size.infinite,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom painter for animated checkmark
class CheckmarkPainter extends CustomPainter {
  final double progress;

  CheckmarkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final checkPath = Path();

    // Define checkmark points
    final start = Offset(center.dx - 20, center.dy);
    final middle = Offset(center.dx - 5, center.dy + 15);
    final end = Offset(center.dx + 20, center.dy - 15);

    if (progress <= 0.5) {
      // First half: draw from start to middle
      final currentProgress = progress / 0.5;
      final currentPoint = Offset.lerp(start, middle, currentProgress)!;
      checkPath.moveTo(start.dx, start.dy);
      checkPath.lineTo(currentPoint.dx, currentPoint.dy);
    } else {
      // Second half: draw from middle to end
      final currentProgress = (progress - 0.5) / 0.5;
      final currentPoint = Offset.lerp(middle, end, currentProgress)!;
      checkPath.moveTo(start.dx, start.dy);
      checkPath.lineTo(middle.dx, middle.dy);
      checkPath.lineTo(currentPoint.dx, currentPoint.dy);
    }

    canvas.drawPath(checkPath, paint);
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Custom painter for confetti animation
class ConfettiPainter extends CustomPainter {
  final double progress;
  final List<ConfettiParticle> particles;

  ConfettiPainter(this.progress) : particles = _generateParticles();

  static List<ConfettiParticle> _generateParticles() {
    final colors = [
      AppColors.primaryGreen,
      AppColors.gold,
      AppColors.infoBlue,
      AppColors.warningOrange,
      AppColors.mutedGreen,
    ];

    return List.generate(50, (index) {
      return ConfettiParticle(
        color: colors[index % colors.length],
        startX: (index % 10) * 40.0,
        startY: -20,
        velocity: 100 + (index % 3) * 50.0,
        rotation: (index % 6) * 60.0,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()..color = particle.color;

      final currentY = particle.startY + (particle.velocity * progress);
      final currentX = particle.startX + (20 * progress);
      final rotation = particle.rotation * progress;

      if (currentY > size.height) continue;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(rotation * 3.14159 / 180);
      
      // Draw confetti piece
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-3, -6, 6, 12),
          const Radius.circular(2),
        ),
        paint,
      );
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Confetti particle model
class ConfettiParticle {
  final Color color;
  final double startX;
  final double startY;
  final double velocity;
  final double rotation;

  ConfettiParticle({
    required this.color,
    required this.startX,
    required this.startY,
    required this.velocity,
    required this.rotation,
  });
}

/// Micro-interaction for button press
class ButtonPressAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration duration;

  const ButtonPressAnimation({
    super.key,
    required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  State<ButtonPressAnimation> createState() => _ButtonPressAnimationState();
}

class _ButtonPressAnimationState extends State<ButtonPressAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Ripple effect animation
class RippleAnimation extends StatefulWidget {
  final Widget child;
  final Color rippleColor;
  final VoidCallback? onTap;

  const RippleAnimation({
    super.key,
    required this.child,
    this.rippleColor = AppColors.primaryGreen,
    this.onTap,
  });

  @override
  State<RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
    });
    _controller.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: CustomPaint(
        painter: RipplePainter(
          animation: _animation,
          center: _tapPosition,
          color: widget.rippleColor,
        ),
        child: widget.child,
      ),
    );
  }
}

/// Custom painter for ripple effect
class RipplePainter extends CustomPainter {
  final Animation<double> animation;
  final Offset? center;
  final Color color;

  RipplePainter({
    required this.animation,
    this.center,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (center == null) return;

    final paint = Paint()
      ..color = color.withOpacity(0.3 * (1 - animation.value))
      ..style = PaintingStyle.fill;

    final radius = animation.value * size.width;
    canvas.drawCircle(center!, radius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.animation != animation || oldDelegate.center != center;
  }
}

/// Heart animation for likes
class HeartAnimation extends StatefulWidget {
  final bool isLiked;
  final VoidCallback? onToggle;
  final Color likedColor;
  final Color unlikedColor;
  final double size;

  const HeartAnimation({
    super.key,
    required this.isLiked,
    this.onToggle,
    this.likedColor = AppColors.errorRed,
    this.unlikedColor = Colors.grey,
    this.size = 24,
  });

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isLiked) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(HeartAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLiked != widget.isLiked) {
      if (widget.isLiked) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    return GestureDetector(
      onTap: widget.onToggle,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _rotateAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotateAnimation.value,
              child: Icon(
                widget.isLiked ? Icons.favorite : Icons.favorite_border,
                color: widget.isLiked ? widget.likedColor : widget.unlikedColor,
                size: widget.size,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Floating action with success feedback
class FloatingSuccessAction extends StatefulWidget {
  final IconData icon;
  final String successMessage;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const FloatingSuccessAction({
    super.key,
    required this.icon,
    required this.successMessage,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  State<FloatingSuccessAction> createState() => _FloatingSuccessActionState();
}

class _FloatingSuccessActionState extends State<FloatingSuccessAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _colorAnimation = ColorTween(
      begin: widget.backgroundColor ?? AppColors.primaryGreen,
      end: AppColors.successGreen,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() async {
    widget.onPressed();
    
    setState(() => _showSuccess = true);
    await _controller.forward();
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _controller.reverse();
        setState(() => _showSuccess = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _colorAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FloatingActionButton(
            onPressed: _handlePress,
            backgroundColor: _colorAnimation.value,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _showSuccess
                  ? const Icon(Icons.check, key: ValueKey('success'))
                  : Icon(widget.icon, key: const ValueKey('normal')),
            ),
          ),
        );
      },
    );
  }
}

/// Page transition with success feedback
class SuccessPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final String successMessage;

  SuccessPageRoute({
    required this.page,
    required this.successMessage,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 500),
  );
}