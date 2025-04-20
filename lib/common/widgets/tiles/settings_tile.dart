import 'package:flutter/material.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.text,
    this.trailingIcon,
    this.onPressed,
  });

  final IconData icon;
  final String text;
  final Widget? trailingIcon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: dark ? AColors.songTitleColor : AColors.textPrimary),
              const SizedBox(width: 8),
              Text(text, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          trailingIcon?? IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.arrow_forward_ios, color: dark ? AColors.songTitleColor : AColors.textPrimary, size: 20,),
          ),
        ],
      ),
    );
  }
}