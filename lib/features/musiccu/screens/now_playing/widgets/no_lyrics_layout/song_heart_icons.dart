import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/icons/container_icon.dart';
import 'package:musiccu/features/musiccu/controllers/favorite_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/now_playing_yes_lyrics.dart';
import 'package:musiccu/utils/constants/colors.dart';

class SongHeartIcon extends StatelessWidget {
  const SongHeartIcon({super.key, required this.song, required this.showIcon});

  final SongModel song;
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
                    () => NowPlayingYesLyrics(song: song, showIcon: showIcon),
                    duration: Duration(milliseconds: 600),
                  ),
            ),
          ),
          Obx(
            () => ContainerIcon(
              icon1: !FavoriteController.instance.isFavoriteRx(song).value ? Icon(
                CupertinoIcons.heart,
                color: AColors.artistTextColorDark,
              ) : Icon(
                CupertinoIcons.heart_fill,
                color: Colors.red,
              ),
              height: 50,
              width: 50,
              onTap: () => FavoriteController.instance.toggleFavorite(song),
            ),
          ),
        ],
      ),
    );
  }
}
