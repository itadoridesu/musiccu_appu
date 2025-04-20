import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/features/musiccu/models/song_model.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/widgets/no_lyrics_layout/no_lyrics.dart';
import 'package:musiccu/common/widgets/music/music_control_row.dart';

class NowPlayingNoLyrics extends StatelessWidget {
  const NowPlayingNoLyrics({super.key, required this.song, required this.showIcon});

  final SongModel song;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
 

    return Scaffold(
      appBar: AAppBar(
        icon1: Icons.keyboard_arrow_down,
        icon2: Icons.graphic_eq,
        title: "Now Playing",
        onTapL: Get.back,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(right: 24, left: 24, top: 8, bottom: 8),
        child: NoLyricsLayout(song: song, showIcon: showIcon),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: MusicControlRow(),
      ),
    );
  }
}
