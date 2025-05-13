import 'package:flutter/material.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/common/widgets/texts/moving_text.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';

class SongtileSimple extends StatelessWidget {
  const SongtileSimple({
    super.key,
    required this.song,
    this.heigt = 85,
    this.width = 85,
    this.radius = 20,
    this.onTap,
    this.songNameStyle,
    this.artistNameStyle,
    this.heightBtwText = 0,
    this.movingText = false,
    this.showHero = false,
  });

  final SongModel song;
  final double heigt, width, radius, heightBtwText;
  final VoidCallback? onTap;
  final TextStyle? songNameStyle;
  final TextStyle? artistNameStyle;
  final bool movingText;
  final bool showHero;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias, // required for ripple to clip to radius
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             !showHero ? RoundedImage(
                imageUrl: song.imagePath,
                height: heigt,
                width: width,
                applyImageRadius: true,
                borderRadius: radius,)
              : Hero(
              tag: 'image_${song.id}_${'hide'}',
               child: RoundedImage(
                imageUrl: song.imagePath,
                height: heigt,
                width: width,
                applyImageRadius: true,
                borderRadius: radius,
                           ),
             ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !movingText? Text(
                    song.songName,
                    style: songNameStyle ?? Theme.of(context).textTheme.headlineMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ) : MovingText(text: song.songName, width: 200),
                  SizedBox(height: heightBtwText,),
                  Text(
                    song.artistName,
                    style: artistNameStyle ?? Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}