import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musiccu/common/widgets/texts/three_textx_row.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class UpNextBox extends StatelessWidget {
  const UpNextBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: dark ? AColors.darkContainer : AColors.inverseDarkGrey,
        ),
    
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 15.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Up Next",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
    
                  Icon(CupertinoIcons.list_dash)
                ],
              ),
    
              const SizedBox(height: 10,),
    
              ThreeTextsRow(text1: "I'm Fine", text2: "Ashe", text3: "2.16",),
    
              const SizedBox(height: 3,),
    
              ThreeTextsRow(text1: "Drown", text2: "Dabin", text3: "4.19",),
            ],
          ),
        ),
      ),
    );
  }
}