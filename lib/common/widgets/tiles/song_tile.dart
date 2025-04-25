import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:musiccu/common/widgets/icons/container_icon.dart';
import 'package:musiccu/common/widgets/icons/pause_stop.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/common/widgets/texts/song_artist.dart';
import 'package:musiccu/features/musiccu/controllers/favorite_controller.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/now_playing.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.song, // Accepting SongModel as a parameter
    this.showIcon = true,
    this.isPauseStop = false,
    this.icon1 = const Icon(CupertinoIcons.heart),
    this.icon2 = const Icon(Icons.more_horiz),
    this.pauseIcon = const Icon(Icons.pause),
    this.stopIcon = const Icon(Icons.stop),
    this.padding = 8,
    this.onTap,
  });

  final SongModel song; // Using SongModel here
  final bool showIcon;
  final bool isPauseStop;
  final Icon icon1;
  final Icon icon2;
  final Icon pauseIcon;
  final Icon stopIcon;
  final double padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.put(FavoriteController());

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap:
          onTap ??
          () => Get.to(
            () => NowPlayingNoLyrics(song: song, showIcon: showIcon),
            duration: Duration(milliseconds: 600),
          ),
      child: Padding(
        padding: EdgeInsets.only(bottom: padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // The image is always displayed
                Hero(
                  tag: 'image_${song.id}_${showIcon ? 'show' : 'hide'}',
                  child: RoundedImage(
                    imageUrl: song.imagePath,
                    height: 85,
                    width: 85,
                    applyImageRadius: true,
                  ),
                ),

                const SizedBox(width: 10),

                // Song and Artist Texts
                SongArtistText(
                  song: song,
                  showIcon: showIcon,
                  isEllipsis: true,
                ),
              ],
            ),

            Row(
              children: [
                // Icon 1 (Heart Icon) if showIcon is true
                if(showIcon) Obx(() {
                  return ContainerIcon(
                    icon1:
                        favoriteController.isFavoriteRx(song).value
                            ? const Icon(
                              CupertinoIcons.heart_fill,
                              color: Colors.red,
                            )
                            : const Icon(CupertinoIcons.heart),
                    height: 50,
                    width: 50,
                    onTap: () => favoriteController.toggleFavorite(song),
                    color: Colors.transparent,
                  );
                }),
  
                // Icon 2 (Three Dots Icon) if showIcon is true
                if (showIcon)
                  GestureDetector(
                    onTap: () => SongController.instance.showSongMenu(song, context),
                    child: icon2,
                  ),

                // Pause icon with white container and black icon in dark mode, vice versa in light mode
                if (isPauseStop) Hero(tag: "pause", child: PaustStopButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
