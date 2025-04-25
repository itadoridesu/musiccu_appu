import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:musiccu/common/styles/hilal_slider.dart';
import 'package:musiccu/features/musiccu/controllers/audio_controller.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class MusicBar extends StatelessWidget {
  const MusicBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final audioController = AudioController.instance;

    return Obx(() {
      final currentPosition = audioController.currentPosition.value;
      final totalDuration = audioController.totalDuration.value;
      final sliderPosition = audioController.sliderPosition.value;

      // Use sliderPosition while dragging, otherwise use currentPosition
      final displayPosition = audioController.isDragging.value
          ? sliderPosition
          : currentPosition;

      // Ensure position never exceeds duration
      final clampedPosition = displayPosition > totalDuration
          ? totalDuration
          : displayPosition;

      final safePositionMs = clampedPosition.inMilliseconds.toDouble();
      final durationMs = totalDuration.inMilliseconds.toDouble();

      return Stack(
        children: [
          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: HalfMoonThumbShape(thumbRadius: 7.5, dark: dark),
              trackHeight: 4,
              overlayColor: AColors.primary.withOpacity(0.2),
            ),
            child: Slider(
              value: safePositionMs.clamp(0, durationMs),
              min: 0,
              max: durationMs,
              onChangeStart: (value) {
                // Start dragging (store current position)
                audioController.startDragging(currentPosition);
              },
              onChanged: (value) {
                // Update UI position while dragging (without affecting audio)
                audioController.updateSliderPosition(
                  Duration(milliseconds: value.toInt()),
                );
              },
              onChangeEnd: (value) {
                // Seek to new position only when released
                audioController.seekToPosition(
                  Duration(milliseconds: value.toInt()),
                );
                audioController.stopDragging();
              },
              activeColor: AColors.primary,
              inactiveColor: dark ? AColors.greyContainer : AColors.inverseDarkGrey,
            ),
          ),

          // Time labels (showing dragged position while sliding)
          Positioned(
            bottom: -4,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Current position (or dragged position)
                  Text(
                    THelperFunctions.formatDuration(clampedPosition),
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                  // Total duration
                  Text(
                    THelperFunctions.formatDuration(totalDuration),
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}