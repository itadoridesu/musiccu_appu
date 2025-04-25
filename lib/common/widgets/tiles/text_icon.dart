import 'package:flutter/material.dart';
import 'package:musiccu/features/personlization/controllers/theme_controller.dart';
import 'package:musiccu/utils/constants/colors.dart';

class TextIcon extends StatelessWidget {
  const TextIcon({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dark = ThemeController.instance.isDarkMode.value;
    final defaultColor = dark ? AColors.songTitleColor : AColors.songTitleColorDark;
    final effectiveColor = color ?? defaultColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: TextStyle(color: effectiveColor)),
        IconButton(
          icon: Icon(icon, color: effectiveColor),
          onPressed: onPressed,
        ),
      ],
    );
  }
}