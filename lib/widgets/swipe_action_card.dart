import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SwipeActionCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onFavorite;
  final String favoriteLabel;

  const SwipeActionCard({
    super.key,
    required this.child,
    this.onFavorite,
    this.favoriteLabel = 'Favorite',
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade400, Colors.red.shade400],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.white, size: 32),
            SizedBox(height: 4),
            Text('Favorite', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.pink.shade400],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.white, size: 32),
            SizedBox(height: 4),
            Text('Favorite', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        HapticFeedback.mediumImpact();
        if (onFavorite != null) {
          onFavorite!();
        }
        return false;
      },
      child: child,
    );
  }
}
