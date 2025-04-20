import 'package:flutter/material.dart';
import 'package:musiccu/utils/constants/colors.dart';

class HalfMoonThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final bool dark;

  HalfMoonThumbShape({this.thumbRadius = 10, required this.dark});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint1 = Paint()..color = dark ? AColors.songTitleColor : AColors.inverseDarkGrey;
    final paint2 = Paint()..color = AColors.primary;

    final rect = Rect.fromCircle(center: center, radius: thumbRadius);

    // Draw left half (white)
    canvas.drawArc(rect, 0.5 * 3.14, 3.14, true, paint1);

    // Draw right half (primary color)
    canvas.drawArc(rect, -0.5 * 3.14, 3.14, true, paint2);
  }
}
