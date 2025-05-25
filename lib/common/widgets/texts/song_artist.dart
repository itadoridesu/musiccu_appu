import 'package:flutter/material.dart';
import 'package:musiccu/common/widgets/texts/moving_text.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';

class SongArtistText extends StatelessWidget {
  const SongArtistText({
    super.key,
    required this.song,
    required this.showIcon,
    this.height = 4,
    this.isEllipsis = false,
    this.maxWidth = 0.4,
    bool? moving,
  }) : moving = moving ?? !showIcon;

  final SongModel song;
  final bool showIcon;
  final double height;
  final bool isEllipsis;
  final double maxWidth;
  final bool moving;

  @override
  Widget build(BuildContext context) {
    final calculatedMaxWidth = MediaQuery.of(context).size.width * maxWidth;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        moving
            ? ConstrainedBox(
          constraints: BoxConstraints(maxWidth: calculatedMaxWidth),
          child: MovingText(text: song.songName),
              )
            : Hero(
          tag: 'songName_${song.id}_${showIcon ? 'show' : 'hide'}',
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: calculatedMaxWidth),
            child: Text(
              song.songName,
              overflow: isEllipsis ? TextOverflow.ellipsis : TextOverflow.visible,
              style: Theme.of(context).textTheme.headlineMedium!
            .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
              ),
        SizedBox(height: height),
        Hero(
          tag: 'artistName_${song.id}_${showIcon ? 'show' : 'hide'}',
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: calculatedMaxWidth),
            child: Text(
              song.artistName,
              overflow: isEllipsis ? TextOverflow.ellipsis : TextOverflow.visible,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 15)
            ),
          ),
        ),
      ],
    );
  }
}
