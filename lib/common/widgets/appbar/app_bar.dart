import 'package:flutter/material.dart';
import 'package:musiccu/utils/device/device_utility.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class AAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AAppBar({
    super.key,
    this.icon1,
    this.icon2,
    required this.title,
    this.onTapA,
    this.onTapL,
  });

  final IconData? icon1;
  final IconData? icon2;
  final String title;
  final VoidCallback? onTapL;
  final VoidCallback? onTapA;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return AppBar(
      leading: icon1 != null
          ? Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: onTapL,
                child: Icon(icon1, color: dark ? Colors.white : Colors.black),
              ),
            )
          : null,
      title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      centerTitle: true,
      actions: [
        if (icon2 != null)
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: onTapA,
              child: Icon(icon2, color: dark ? Colors.white : Colors.black),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
