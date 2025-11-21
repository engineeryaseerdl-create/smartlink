import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final Widget? sidebar;
  final Widget? topAppBar;
  final Widget? bottomNavigation;
  final bool showSidebarOnDesktop;
  final double? maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.sidebar,
    this.topAppBar,
    this.bottomNavigation,
    this.showSidebarOnDesktop = true,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context) && showSidebarOnDesktop && sidebar != null) {
      return _buildDesktopLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: topAppBar as PreferredSizeWidget?,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: sidebar!,
          ),
          // Main content
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth ?? ResponsiveUtils.getMaxContentWidth(context),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: topAppBar as PreferredSizeWidget?,
      body: child,
      bottomNavigationBar: bottomNavigation,
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.childAspectRatio,
    this.mainAxisSpacing = AppSpacing.md,
    this.crossAxisSpacing = AppSpacing.md,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.getGridCrossAxisCount(context);
    
    return GridView.builder(
      padding: padding ?? ResponsiveUtils.getResponsivePagePadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio ?? (ResponsiveUtils.isDesktop(context) ? 0.8 : 0.7),
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context)) {
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.getMaxContentWidth(context),
          minHeight: MediaQuery.of(context).size.height,
        ),
        padding: padding ?? ResponsiveUtils.getResponsivePagePadding(context),
        margin: margin,
        decoration: backgroundColor != null 
          ? BoxDecoration(color: backgroundColor)
          : null,
        child: SingleChildScrollView(child: child),
      );
    } else {
      return Container(
        padding: padding ?? ResponsiveUtils.getResponsivePagePadding(context),
        margin: margin,
        decoration: backgroundColor != null 
          ? BoxDecoration(color: backgroundColor)
          : null,
        child: child,
      );
    }
  }
}
