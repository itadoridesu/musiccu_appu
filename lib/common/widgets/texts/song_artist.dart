import 'package:flutter/material.dart';
import 'package:musiccu/features/musiccu/models/song_model.dart';

class SongArtistText extends StatelessWidget {
  const SongArtistText({
    super.key,
    required this.song,
    required this.showIcon,  // New parameter to handle icon condition
    this.height = 4,
    this.isEllipsis = false,  // New parameter for ellipsis functionality
  });

  final SongModel song;
  final bool showIcon;  // New parameter
  final double height;
  final bool isEllipsis; // New parameter for truncation

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'songName_${song.id}_${showIcon ? 'show' : 'hide'}', // Adding showIcon condition to tag
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4), // Limit the width to 70% of screen width
            child: Text(
              song.songName,
              overflow: isEllipsis ? TextOverflow.ellipsis : TextOverflow.visible, // Apply ellipsis or show full text
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: height),
        Hero(
          tag: 'artistName_${song.id}_${showIcon ? 'show' : 'hide'}', // Adding showIcon condition to tag
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4), // Limit the width to 70% of screen width
            child: Text(
              song.artistName,
              overflow: isEllipsis ? TextOverflow.ellipsis : TextOverflow.visible, // Apply ellipsis or show full text
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ],
    );
  }
}
