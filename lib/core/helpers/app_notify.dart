import 'dart:async';
import 'package:flutter/material.dart';

class AppNotify {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show({
    required BuildContext context,
    required String message,
    NotifyType type = NotifyType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    _remove();

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final style = _getStyle(type);

    _entry = OverlayEntry(
      builder: (context) {
        return _TopToast(
          message: message,
          icon: style.icon,
          color: style.color,
        );
      },
    );

    overlay.insert(_entry!);

    _timer = Timer(duration, () {
      _remove();
    });
  }

  static void _remove() {
    _timer?.cancel();
    _timer = null;

    _entry?.remove();
    _entry = null;
  }

  static _NotifyStyle _getStyle(NotifyType type) {
    switch (type) {
      case NotifyType.success:
        return _NotifyStyle(color: Colors.green, icon: Icons.check_circle);
      case NotifyType.error:
        return _NotifyStyle(color: Colors.red, icon: Icons.error);
      case NotifyType.warning:
        return _NotifyStyle(color: Colors.orange, icon: Icons.warning);
      case NotifyType.info:
      default:
        return _NotifyStyle(color: Colors.blue, icon: Icons.info);
    }
  }
}

enum NotifyType { success, error, warning, info }

class _NotifyStyle {
  final Color color;
  final IconData icon;
  _NotifyStyle({required this.color, required this.icon});
}

class _TopToast extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;

  const _TopToast({
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  State<_TopToast> createState() => _TopToastState();
}

class _TopToastState extends State<_TopToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _offset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 12,
      right: 12,
      child: SlideTransition(
        position: _offset,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
