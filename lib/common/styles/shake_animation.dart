// lib/common/widgets/animations/shuffle_animation.dart
import 'package:flutter/material.dart';

class ShuffleAnimation extends StatefulWidget {
  final Widget child;
  final bool isActive;
  
  const ShuffleAnimation({
    super.key,
    required this.child,
    required this.isActive,
  });

  @override
  State<ShuffleAnimation> createState() => _ShuffleAnimationState();
}

class _ShuffleAnimationState extends State<ShuffleAnimation> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(ShuffleAnimation oldWidget) {
    if (widget.isActive != oldWidget.isActive && widget.isActive) {
      _controller.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 0.3 * 
                 (1 - Curves.easeOut.transform(_controller.value)),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}