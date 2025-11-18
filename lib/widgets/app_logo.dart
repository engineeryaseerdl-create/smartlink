import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final double borderRadius;

  const AppLogo({
    super.key,
    this.size = 60,
    this.backgroundColor,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'assets/images/logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.link,
              size: size * 0.6,
              color: const Color(0xFFF88F3A),
            );
          },
        ),
      ),
    );
  }
}