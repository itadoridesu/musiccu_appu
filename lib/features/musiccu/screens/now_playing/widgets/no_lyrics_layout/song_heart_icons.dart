import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/icons/container_icon.dart';
import 'package:musiccu/features/musiccu/controllers/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/now_playing_yes_lyrics.dart';
import 'package:musiccu/utils/constants/colors.dart';

class SongHeartIcon extends StatelessWidget {
  const SongHeartIcon({super.key, required this.showIcon});

  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Hero(
            tag: "lyrics button",
            child: ContainerIcon(
              icon1: Icon(
                CupertinoIcons.music_note_2,
                color: AColors.artistTextColorDark,
              ),
              height: 50,
              width: 50,
              onTap:
                  () => Get.to(
                    () => NowPlayingYesLyrics(showIcon: showIcon),
                    duration: Duration(milliseconds: 500),
                  ),
            ),
          ),
          Obx(() {
            final song = SongController.instance.selectedSong.value;

            return ContainerIcon(
              icon1:
                  !PredefinedPlaylistsController.instance.isFavoriteRx(song!.id).value
                      ? Icon(
                        CupertinoIcons.heart,
                        color: AColors.artistTextColorDark,
                      )
                      : Icon(CupertinoIcons.heart_fill, color: Colors.red),
              height: 50,
              width: 50,
              onTap: () => PredefinedPlaylistsController.instance.toggleFavorite(song!.id),
            );
          }),
        ],
      ),
    );
  }
}
