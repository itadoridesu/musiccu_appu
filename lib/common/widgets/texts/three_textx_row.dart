import 'package:flutter/material.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class ThreeTextsRow extends StatelessWidget {
  const ThreeTextsRow({
    super.key, required this.text1, required this.text2, required this.durationMs,
  });

  final String text1, text2;

  final int durationMs;

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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: dark ? AColors.artistTextColor : AColors.artistTextColorDark),
          ),
        ),
    
        Expanded(
          flex: 1,
          child: Text(
            text2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: dark ? AColors.artistTextColor : AColors.artistTextColorDark),
          ),
        ),
    
        Flexible(
          flex: 1,
          child: Text(
            THelperFunctions.formatDuration(Duration(milliseconds: durationMs)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: dark ? AColors.artistTextColor : AColors.artistTextColorDark),
          ),
        )
      ],
    );
  }
}