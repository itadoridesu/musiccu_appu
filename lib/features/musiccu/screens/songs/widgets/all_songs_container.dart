import 'package:flutter/material.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model.dart';
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

    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color:
            dark
                ? const Color.fromARGB(255, 31, 30, 30)
                : AColors.inverseDarkGrey,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
            songs.map((song) {
              // Mapping each song to a SongTile
              return SongTile(
                song: song,
                showIcon: true,
                isPauseStop: false,
                onTap: () {
                    songController.updateSelectedSong(song, navigate: true);
                },
              );
            }).toList(),
      ),
    );
  }
}
