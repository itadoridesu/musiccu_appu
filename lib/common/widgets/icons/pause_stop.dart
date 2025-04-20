import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:musiccu/features/musiccu/controllers/audio_controller.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class PaustStopButton extends StatelessWidget {
  const PaustStopButton({
    super.key, this.color, this.height = 50, this.width = 50, this.border = 50, this.size = 30,
  });

  final Color? color;
  final double height, width, border, size;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);

    final controller = AudioController.instance;

    return GestureDetector(
      onTap: () => controller.togglePlayPause(),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? (isDarkMode ? Colors.white : AColors.dark),
          borderRadius: BorderRadius.circular(border),
        ),
        child: Obx(
          () => Icon(
            controller.isPlaying.value ? Icons.pause : Icons.play_arrow,  // Correct icon names
            size: size,
            color: isDarkMode ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
