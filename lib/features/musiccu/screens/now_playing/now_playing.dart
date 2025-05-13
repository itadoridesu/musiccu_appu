import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/widgets/no_lyrics_layout/no_lyrics.dart';
import 'package:musiccu/common/widgets/music/music_control_row.dart';

class NowPlayingNoLyrics extends StatelessWidget {
  const NowPlayingNoLyrics({super.key, required this.showIcon});

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
        child: NoLyricsLayout(showIcon: showIcon)
       
        
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: MusicControlRow(),
      ),
    );
  }
}
