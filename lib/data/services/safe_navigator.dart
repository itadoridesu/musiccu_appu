// safe_navigator.dart
import 'package:flutter/material.dart';

class SafeScreen extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onScreenReady;

  const SafeScreen({
    super.key,
    required this.child,
    this.onScreenReady,
  });

  @override
  State<SafeScreen> createState() => _SafeScreenState();
}

class _SafeScreenState extends State<SafeScreen> {
  bool _isReady = false;
  
  bool get isReady => _isReady;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await Future.delayed(Duration.zero);
    if (widget.onScreenReady != null) {
      await widget.onScreenReady!();
    }
    if (mounted) {
      setState(() => _isReady = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isReady,
      onPopInvoked: (didPop) async {
        if (!didPop && !_isReady) return;
      },
      child: widget.child,
    );
  }
}