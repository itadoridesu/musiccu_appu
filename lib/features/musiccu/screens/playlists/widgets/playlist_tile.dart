import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/common/widgets/select/select_screen.dart';
import 'package:musiccu/common/widgets/select/selection_controller.dart';
import 'package:musiccu/features/musiccu/controllers/playlists_controller.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class PlayListTile extends StatelessWidget {
  const PlayListTile({
    super.key,
    required this.playlist,
    this.onTap,
    this.onLongPress,
    this.icon
  });

  final PlaylistModel playlist;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final playlistController = PlaylistController.instance;

    // Get first two songs using controller method
    final playlistSongs = playlistController.getFirstTwoSongs(playlist);
    final hasSongs = playlistSongs.isNotEmpty;

    final firstSong = hasSongs ? playlistSongs[0] : null;
    final secondSong = playlistSongs.length > 1 ? playlistSongs[1] : null;

    return GestureDetector(
      onLongPress:
          onLongPress ??
          () {
            // Ensure the controller is created first
            if (!Get.isRegistered<SelectionController<PlaylistModel>>()) {
              Get.put(SelectionController<PlaylistModel>());
            }
            final selectionController =
                Get.find<SelectionController<PlaylistModel>>();

            selectionController
                .clearSelection(); // Optional: remove previous selection
            selectionController.toggleSelection(
              playlist.id,
            ); // Pre-select the long-pressed song

            Get.to(
              () => SelectionScreen<PlaylistModel>(
                items: playlistController.playlists,
                getId: (playlist) => playlist.id,
                buildTile:
                    (playlist) => PlayListTile(
                      playlist: playlist,
                      onTap: () {},
                      onLongPress: () {},
                    ),
                selectionController: selectionController,
              ),
            );
          },
      onTap:
          onTap ??
          () {
            playlistController.updatePlaylist(playlist, navigate: true);
            playlistController.selectedPlaylist.value!.coverImagePath =
                firstSong!.imagePath;
          },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color:
                dark
                    ? const Color.fromARGB(255, 31, 30, 30)
                    : AColors.songTitleColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image - Use first song's image or default
              RoundedImage(
                imageUrl: firstSong?.imagePath ?? "",
                height: 100,
                width: 100,
                applyImageRadius: true,
                borderRadius: 20,
              ),
              const SizedBox(width: 10),

              // Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Playlist name
                    Row(
                      children: [
                        icon ?? Text(""),
                        const SizedBox(width: 4,),
                        Expanded(
                          child: Text(
                            playlist.name,
                            style: Theme.of(context).textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    // First song name
                    _RowedText(
                      dark,
                      context,
                      firstSong?.songName ?? "No songs",
                      icon: Icons.music_note,
                    ),

                    // Second song name or empty
                    if (secondSong != null)
                      _RowedText(
                        dark,
                        context,
                        secondSong.songName,
                        icon: Icons.music_note,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${playlist.songIds.length}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _RowedText(
    bool dark,
    BuildContext context,
    String text, {
    IconData? icon,
  }) {
    return Row(
      children: [
        Icon(
          icon ?? Icons.music_note,
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
