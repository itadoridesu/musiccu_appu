import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:musiccu/common/widgets/icons/container_icon.dart';
import 'package:musiccu/common/widgets/icons/pause_stop.dart';
import 'package:musiccu/features/musiccu/controllers/que_controller.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class MusicControlRow extends StatelessWidget {
  const MusicControlRow({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() {
          final isShuffle = QueueController.instance.isShuffled.value;
          final color =
              isShuffle
                  ? (dark ? AColors.artistTextColor : Colors.black)
                  : (dark
                      ? AColors.greyContainer
                      : AColors.artistTextColorDark);

          return ContainerIcon(
            icon1: Icon(CupertinoIcons.shuffle, color: color),
            height: 50,
            width: 50,
            onTap: () => QueueController.instance.toggleShuffle(),
            color: Colors.transparent,
          );
        }),
        ContainerIcon(
          icon1: Icon(
            Icons.skip_previous,
            color: dark ? AColors.artistTextColor : AColors.artistTextColorDark,
          ),
          height: 50,
          width: 50,
          onTap: () => QueueController.instance.movePrevious(),
        ),
        Hero(
          tag: "pause",
          child: PaustStopButton(height: 70, width: 70, size: 40),
        ),
        ContainerIcon(
          icon1: Icon(
            Icons.skip_next,
            color: dark ? AColors.artistTextColor : AColors.artistTextColorDark,
          ),
          height: 50,
          width: 50,
          onTap: () => QueueController.instance.moveNext(),
        ),
        Obx(() {
          final repeatMode = QueueController.instance.repeatMode.value;
          IconData icon;
          Color color;

          // icon = queueController.repeatMode.value == RepeatMode.one
          //               ? CupertinoIcons.repeat_1
          //               : CupertinoIcons.repeat;
          //           final color = queueController.repeatMode.value == RepeatMode.off
          //               ? Colors.grey
          //               : isDarkMode ? AColors.songTitleColor : AColors.songTitleColorDark;

          switch (repeatMode) {
            case RepeatMode.off:
              icon = CupertinoIcons.repeat;
              color =
                  dark ? AColors.greyContainer : AColors.artistTextColorDark;
              break;
            case RepeatMode.one:
              icon = CupertinoIcons.repeat_1;
              color = dark ? AColors.artistTextColor : Colors.black;
              break;
            case RepeatMode.all:
              icon = CupertinoIcons.repeat;
              color = dark ? AColors.artistTextColor : Colors.black;
              break;
          }

          return ContainerIcon(
            icon1: Icon(icon, color: color),
            height: 50,
            width: 50,
            onTap: () => QueueController.instance.toggleRepeatMode(),
            color: Colors.transparent,
          );
        }),
      ],
    );
  }
}
