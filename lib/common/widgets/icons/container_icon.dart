import 'package:flutter/material.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class ContainerIcon extends StatelessWidget {
  const ContainerIcon({
    super.key,
    required this.icon1,
    this.color,
    required this.height, 
    required this.width,
    required this.onTap,
    this.radius = 50,
  });

  final Icon icon1;
  final Color? color;
  final double height, width, radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias, // required for ripple to clip to radius
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: color ?? (dark ? AColors.darkContainer : AColors.inverseDarkGrey),
          ),
          child: Center(
            child: Icon(
              icon1.icon,
              color: icon1.color,
              size: icon1.size,
            ),
          ),
        ),
      ),
    );
  }
}
