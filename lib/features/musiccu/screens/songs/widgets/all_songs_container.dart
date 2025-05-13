import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:musiccu/features/musiccu/controllers/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/que_controller.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/common/widgets/tiles/song_tile.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class AllSongsContainer extends StatelessWidget {
  const AllSongsContainer({required this.songs, super.key});
  final List<SongModel> songs;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final songController = SongController.instance;
    final queueController = QueueController.instance;

    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color:
            dark
                ? const Color.fromARGB(255, 31, 30, 30)
                : AColors.inverseDarkGrey,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          // Reverse the index to show newest first
          final reversedIndex = songs.length - 1 - index;
          final song = songs[reversedIndex];

          return SongTile(
            song: song,
            showIcon: true,
            isPauseStop: false,
            index: reversedIndex, 
            onTap: () {
              // Create a reversed queue for playback if needed
              final playbackQueue = List<SongModel>.from(songs.reversed);
              queueController.setQueue(playbackQueue, startingIndex: index);
              songController.updateSelectedSong(song, navigate: true);
            },
          );
        },
      ),
    );
  }
}
