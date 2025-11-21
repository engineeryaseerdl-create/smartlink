import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final bool isOnline;
  final String? label;

  const StatusIndicator({
    super.key,
    required this.isOnline,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isOnline ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        if (label != null) ...[
          const SizedBox(width: 4),
          Text(
            label!,
            style: TextStyle(
              fontSize: 12,
              color: isOnline ? Colors.green : Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}

class OrderProgressBar extends StatelessWidget {
  final double progress;
  final String status;

  const OrderProgressBar({
    super.key,
    required this.progress,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(status, style: const TextStyle(fontSize: 9), overflow: TextOverflow.ellipsis),
            ),
            Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 9)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress == 1.0 ? Colors.green : Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
