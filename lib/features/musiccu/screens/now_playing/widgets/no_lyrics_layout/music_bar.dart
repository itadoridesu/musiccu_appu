import 'package:flutter/material.dart';
import 'package:musiccu/common/styles/hilal_slider.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class MusicBar extends StatelessWidget {
  const MusicBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Stack(
      children: [
        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: HalfMoonThumbShape(thumbRadius: 9, dark: dark),
            trackHeight: 4,
            overlayColor: AColors.primary.withOpacity(0.2),
          ),
          child: Slider(
            value: 40,
            min: 0,
            max: 100,
            onChanged: (value) {},
            activeColor: AColors.primary,
            inactiveColor: dark? AColors.greyContainer : AColors.inverseDarkGrey
          ),
        ),
    
        Positioned(
          bottom: -4, 
          left: 24,
          right: 24,
          child: SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "1.46",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "3.40",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}