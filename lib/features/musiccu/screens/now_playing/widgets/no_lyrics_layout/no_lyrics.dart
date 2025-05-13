import 'package:flutter/material.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/widgets/no_lyrics_layout/music_bar.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/widgets/no_lyrics_layout/song_heart_icons.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/widgets/no_lyrics_layout/song_vertical.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/widgets/no_lyrics_layout/up_next_box.dart';

class NoLyricsLayout extends StatelessWidget {
  const NoLyricsLayout({
    super.key,
    required this.showIcon,
  });

  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SongVerticaled(showIcon: showIcon),
    
        MusicBar(),
    
        const SizedBox(height: 17),
    
        SongHeartIcon(showIcon: showIcon),
    
        const SizedBox(height: 22),
    
        UpNextBox()
      ],
    );
  }
}