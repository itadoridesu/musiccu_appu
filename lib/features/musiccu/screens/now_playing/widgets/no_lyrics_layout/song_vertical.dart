import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/common/widgets/texts/song_artist.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';

class SongVerticaled extends StatelessWidget {
  const SongVerticaled({
    super.key,
    required this.showIcon,
  });

  final bool showIcon;

  @override
  Widget build(BuildContext context) { 

    return Obx(
      () {  
        final song = SongController.instance.selectedSong.value;
        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'image_${song!.id}_${showIcon ? 'show' : 'hide'}',
            child: RoundedImage(
              imageUrl: song.imagePath,
              height: 350,
              width: 350,
              applyImageRadius: true,
            ),
          ),
          const SizedBox(height: 9),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SongArtistText(song: song, showIcon: showIcon, maxWidth: 0.7, moving: false,),
          ),
        ],
      );
  });
  }
}