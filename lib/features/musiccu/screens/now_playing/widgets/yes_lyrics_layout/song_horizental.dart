import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:musiccu/common/widgets/icons/container_icon.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/common/widgets/texts/song_artist.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class SongHorizontal extends StatelessWidget {
  const SongHorizontal({super.key, required this.showIcon});

  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(() {
      final song = SongController.instance.selectedSong.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'image_${song!.id}_${showIcon ? 'show' : 'hide'}',
                child: RoundedImage(
                  imageUrl: song.imagePath,
                  height: 110,
                  width: 110,
                  applyImageRadius: true,
                  borderRadius: 110,
                  rotate: true,
                ),
              ),

              const SizedBox(width: 13),

              Padding(
                padding: EdgeInsets.only(top: 7),
                child: SongArtistText(
                  song: song,
                  showIcon: showIcon,
                  maxWidth: 0.47,
                ),
              ),
            ],
          ),

          Hero(
            tag: "lyrics button",
            child: ContainerIcon(
              icon1: Icon(
                CupertinoIcons.music_note_2,
                color: dark ? AColors.inverseDarkGrey : AColors.textPrimary,
              ),
              height: 50,
              width: 50,
              onTap: () => Get.back(),
            ),
          ),
        ],
      );
    });
  }
}
