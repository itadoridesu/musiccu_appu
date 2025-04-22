import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MovingText extends StatelessWidget {
  const MovingText({
    super.key,
    required this.text,
    this.height = 30,
    this.width = double.infinity,
    this.scrollDirection = TextDirection.rtl,
    this.beginAlignment = Alignment.centerLeft,
    this.endAlignment = Alignment.centerRight,
    this.rounds = 0, // Default to 0 for infinite rounds
    this.textStyle, // Allow passing a custom TextStyle
  });

  final String text;
  final double height;
  final double width;
  final TextDirection scrollDirection;
  final Alignment beginAlignment;
  final Alignment endAlignment;
  final int rounds;
  final TextStyle? textStyle; // Nullable to allow fallback to default

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: beginAlignment,
          end: endAlignment,
          colors: [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [0.0, 0.2, 0.9, 1], // Adjust the fade strength
        ).createShader(bounds),
        blendMode: BlendMode.dstIn,
        child: Marquee(
          text: text,
          style: textStyle ??
              Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold), // Default style
          blankSpace: 20,
          velocity: 25.0,
          textDirection: scrollDirection,
          numberOfRounds: rounds == 0 ? null : rounds, // Infinite if rounds is 0
        ),
      ),
    );
  }
}
