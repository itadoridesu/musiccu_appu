import 'package:flutter/material.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class ThreeTextsRow extends StatelessWidget {
  const ThreeTextsRow({
    super.key, required this.text1, required this.text2, required this.text3,
  });

  final String text1, text2, text3;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            text1,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: dark?AColors.artistTextColor : AColors.artistTextColorDark),
          ),
        ),
    
        Expanded(
          flex: 1,
          child: Text(
            text2,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: dark?AColors.artistTextColor : AColors.artistTextColorDark),
          ),
        ),
    
        Flexible(
          flex: 1,
          child: Text(
            text3,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: dark?AColors.artistTextColor : AColors.artistTextColorDark),
          ),
        )
      ],
    );
  }
}