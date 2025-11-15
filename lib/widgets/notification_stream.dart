import 'package:flutter/material.dart';
import 'dart:async';

class NotificationStream extends StatefulWidget {
  final Widget Function(int count) builder;

  const NotificationStream({super.key, required this.builder});

  @override
  State<NotificationStream> createState() => _NotificationStreamState();
}

class _NotificationStreamState extends State<NotificationStream> {
  late StreamController<int> _controller;
  int _notificationCount = 3;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<int>.broadcast();
    _simulateNotifications();
  }

  void _simulateNotifications() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _notificationCount++;
        _controller.add(_notificationCount);
      }
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _controller.stream,
      initialData: _notificationCount,
      builder: (context, snapshot) {
        return widget.builder(snapshot.data ?? 0);
      },
    );
  }
}