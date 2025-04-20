import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class GlassEffectContainer extends StatelessWidget {
  const GlassEffectContainer({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = 120,
    this.blur = 25,
    this.borderRadius = 25,
    this.borderWidth = 0.25,
    this.borderColor,
  });

  final Widget child;
  final double width;
  final double height;
  final double blur;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    bool dark = THelperFunctions.isDarkMode(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [
                  AColors.white.withAlpha(32),
                  Colors.white.withAlpha(27),
                ]
              : [
                  AColors.inverseDarkGrey.withAlpha(155),
                  AColors.inverseDarkGrey.withAlpha(40),
                ],
        ),
        border: Border.all(
          color: borderColor ?? (dark ? AColors.pageTitleColorDark : Colors.grey),
          width: borderWidth, 
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur /7,
            sigmaY: blur /2,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
