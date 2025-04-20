import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musiccu/common/widgets/icons/container_icon.dart';
import 'package:musiccu/common/widgets/icons/pause_stop.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class MusicControlRow extends StatelessWidget {
  const MusicControlRow({
    super.key});
  

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);


    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ContainerIcon(icon1: Icon(CupertinoIcons.shuffle, color: dark ? AColors.artistTextColor.withOpacity(0.7) : AColors.artistTextColorDark,), height: 50, width: 50, onTap: () {}, color: Colors.transparent,),
              ContainerIcon(icon1: Icon(Icons.skip_previous, color: dark ? AColors.artistTextColor : AColors.artistTextColorDark), height: 50, width: 50, onTap: () {}),
              Hero(tag: "pause" ,child: PaustStopButton(height: 70, width: 70, size: 40),),
              ContainerIcon(icon1: Icon(Icons.skip_next, color: dark ? AColors.artistTextColor : AColors.artistTextColorDark,), height: 50, width: 50, onTap: () {}),
              ContainerIcon(icon1: Icon(CupertinoIcons.repeat, color: dark ? AColors.artistTextColor.withOpacity(0.7) : AColors.artistTextColorDark,), height: 50, width: 50, onTap: () {}, color: Colors.transparent,),
            ],
          );
  }
}

