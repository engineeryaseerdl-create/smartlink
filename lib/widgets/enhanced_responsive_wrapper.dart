import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Enhanced responsive wrapper that prevents overflow issues
class EnhancedResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool useConstraints;
  final double? maxWidth;

  const EnhancedResponsiveWrapper({
    super.key,
    required this.child,
    this.padding,
    this.useConstraints = true,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    Widget wrappedChild = child;

    if (useConstraints) {
      wrappedChild = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? screenWidth,
          maxHeight: screenHeight,
        ),
        child: wrappedChild,
      );
    }

    if (padding != null) {
      wrappedChild = Padding(
        padding: padding!,
        child: wrappedChild,
      );
    }

    return wrappedChild;
  }
}

/// Safe area wrapper for showcase screens
class SafeShowcaseWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;

  const SafeShowcaseWrapper({
    super.key,
    required this.child,
    required this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBackButton)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    title,
                    style: AppTextStyles.heading3,
                  ),
                ],
              ),
            ),
          Expanded(
            child: EnhancedResponsiveWrapper(
              useConstraints: true,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Overflow-safe column for complex layouts
class OverflowSafeColumn extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets? padding;

  const OverflowSafeColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      ),
    );
  }
}

/// Overflow-safe row with wrap fallback
class OverflowSafeRow extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool allowWrap;

  const OverflowSafeRow({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.allowWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (allowWrap && constraints.maxWidth < 600) {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: _getWrapAlignment(),
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: children,
          );
        }

        return Row(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: children.map((child) {
            return Flexible(child: child);
          }).toList(),
        );
      },
    );
  }

  WrapAlignment _getWrapAlignment() {
    switch (mainAxisAlignment) {
      case MainAxisAlignment.center:
        return WrapAlignment.center;
      case MainAxisAlignment.end:
        return WrapAlignment.end;
      case MainAxisAlignment.spaceBetween:
        return WrapAlignment.spaceBetween;
      case MainAxisAlignment.spaceEvenly:
        return WrapAlignment.spaceEvenly;
      case MainAxisAlignment.spaceAround:
        return WrapAlignment.spaceAround;
      default:
        return WrapAlignment.start;
    }
  }
}