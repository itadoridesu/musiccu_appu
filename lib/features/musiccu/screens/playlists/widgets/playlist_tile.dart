import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class PlayListTile extends StatelessWidget {
  const PlayListTile({super.key, required this.playlist});

  final PlaylistModel playlist;

  // Helper to get random songs for testing
  List<SongModel> _getRandomSongs() {
    final allSongs = SongController.instance.songs;
    if (allSongs.isEmpty) return [];
    
    // Get up to 2 random songs
    final random = Random();
    final count = allSongs.length >= 2 ? 2 : allSongs.length;
    return List.generate(count, (index) {
      return allSongs[random.nextInt(allSongs.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final randomSongs = _getRandomSongs(); // Get test songs
    final hasSongs = randomSongs.isNotEmpty;

    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: dark ? const Color.fromARGB(255, 31, 30, 30) : AColors.songTitleColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image - Use first song's image or default icon
              hasSongs && randomSongs[0].imagePath.isNotEmpty
                  ? RoundedImage(
                      imageUrl: randomSongs[0].imagePath,
                      height: 100,
                      width: 100,
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: dark ? AColors.dark : AColors.light,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(Icons.queue_music, size: 40, color: AColors.primary),
                    ),
              const SizedBox(width: 10),

              // Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Playlist name
                    Text(
                      playlist.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 3),

                    // Artist Row - Show first artist if available
                    _RowedText(
                      dark,
                      context,
                      hasSongs ? randomSongs[0].artistName : "No songs",
                      icon: Icons.person_outline,
                    ),

                    // Song count or second song
                    _RowedText(
                      dark,
                      context,
                      hasSongs && randomSongs.length > 1 
                          ? randomSongs[1].songName 
                          : "${playlist.songIds.length} songs",
                      icon: Icons.music_note,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  playlist.songIds.isEmpty ? "0" : "${playlist.songIds.length}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _RowedText(bool dark, BuildContext context, String text, {IconData? icon}) {
    return Row(
      children: [
        Icon(
          icon ?? Icons.info_outline,
          size: 16,
          color: dark ? AColors.textPrimary : AColors.dark,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}