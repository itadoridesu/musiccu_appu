import 'package:flutter/material.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class ContainerText extends StatelessWidget {
  const ContainerText({
    super.key,
    required this.text,
    required this.icon,
    this.height = 55,
    this.width = double.infinity,
    this.color,
    this.borderRadius = 30,
    this.onTap,
  });

  final double height;
  final double width;
  final Color? color;
  final double borderRadius;
  final String text;
  final Icon icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final defaultColor = THelperFunctions.isDarkMode(context)
        ? AColors.darkGray2
        : AColors.pageTitleColor;

    return Material(
       color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias, // required for ripple to clip to radius
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color ?? defaultColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 6),
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}