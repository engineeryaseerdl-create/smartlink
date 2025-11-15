import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SwipeActionCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDelete;
  final VoidCallback? onFavorite;
  final String deleteLabel;
  final String favoriteLabel;

  const SwipeActionCard({
    super.key,
    required this.child,
    this.onDelete,
    this.onFavorite,
    this.deleteLabel = 'Delete',
    this.favoriteLabel = 'Favorite',
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete, color: Colors.white),
            Text(deleteLabel, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.orange,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, color: Colors.white),
            Text(favoriteLabel, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        HapticFeedback.mediumImpact();
        if (direction == DismissDirection.startToEnd && onDelete != null) {
          return await _showConfirmDialog(context, 'Delete', 'Are you sure you want to delete this item?');
        } else if (direction == DismissDirection.endToStart && onFavorite != null) {
          onFavorite!();
          return false;
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd && onDelete != null) {
          onDelete!();
        }
      },
      child: child,
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}