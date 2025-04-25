import 'package:flutter/material.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/widgets/no_lyrics_layout/music_bar.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/widgets/yes_lyrics_layout/lyrics_container.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/widgets/yes_lyrics_layout/song_horizental.dart';


class YesLyricsLayout extends StatelessWidget {
  const YesLyricsLayout({
    super.key,
    required this.song,
    required this.showIcon,
  });

  final SongModel song;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        SongHorizontal(song: song, showIcon: showIcon),

        const SizedBox(height: 21,),

        LyricsContainer(lyrics: "If you’re alone... if it’s just your life, \nyou can use it however you please. \nYou can throw it away or give it to someone else... \nBut if you’re part of a group... if you’re entrusted with the lives of others... \nIt’s not something you can just throw away.",),

        const SizedBox(height: 21,),

        MusicBar()
      ],  
    );
  }
}

