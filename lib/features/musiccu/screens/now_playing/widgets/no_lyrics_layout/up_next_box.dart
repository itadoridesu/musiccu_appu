import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/texts/three_textx_row.dart';
import 'package:musiccu/features/musiccu/controllers/que_controller.dart';
import 'package:musiccu/features/musiccu/screens/queue/queue_screen.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class UpNextBox extends StatelessWidget {
  const UpNextBox({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final queueController = QueueController.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(35),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap:
              () =>
                  Get.off(QueueScreen(), duration: Duration(milliseconds: 600)),
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.queue_music),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // First next song
                  Obx(() {
                    final nextSongs = queueController.nextTwoSongs;
                    return nextSongs[0] != null
                        ? ThreeTextsRow(
                          text1: nextSongs[0]!.songName,
                          text2: nextSongs[0]!.artistName,
                          durationMs: nextSongs[0]!.duration,
                        )
                        : ThreeTextsRow(
                          text1: "No more songs",
                          text2: "",
                          durationMs: 0,
                        );
                  }),
                  const SizedBox(height: 3),
                  // Second next song
                  Obx(() {
                    final nextSongs = queueController.nextTwoSongs;
                    return nextSongs[1] != null
                        ? ThreeTextsRow(
                          text1: nextSongs[1]!.songName,
                          text2: nextSongs[1]!.artistName,
                          durationMs: nextSongs[1]!.duration,
                        )
                        : const SizedBox.shrink(); // Hide if no second song
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
