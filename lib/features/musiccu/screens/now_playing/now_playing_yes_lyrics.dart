import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/common/widgets/music/music_control_row.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/widgets/yes_lyrics_layout/yes_lyrics_layout.dart';
import 'package:musiccu/features/musiccu/screens/songs/songs.dart';

class NowPlayingYesLyrics extends StatelessWidget {
  const NowPlayingYesLyrics({super.key, required this.showIcon});

  final bool showIcon;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AAppBar(
        icon1: Icons.keyboard_arrow_down,
        icon2: Icons.graphic_eq,
        title: "Now Playing",
        onTapL: () {
          Get.back();
          Future.delayed(Duration(milliseconds: 700));
          Get.back();
          
        }
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(right: 24, left: 24, top: 8, bottom: 8),
        child: YesLyricsLayout(showIcon: showIcon),
      ),

      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: MusicControlRow(),
      ),
    );
  }
}