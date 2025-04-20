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
  });

  final Icon icon1;
  final Color? color;
  final double height, width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color ?? (dark ? AColors.darkContainer : AColors.inverseDarkGrey),
        ),
        child: Center(child: icon1),
      ),
    );
  }
}
