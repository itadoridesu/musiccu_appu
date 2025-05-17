import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/container/bottomBarButton.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/common/widgets/select/select_screen.dart';
import 'package:musiccu/common/widgets/select/selection_bar.dart';
import 'package:musiccu/common/widgets/select/selection_operations_ui.dart';
import 'package:musiccu/common/widgets/tiles/songtile_simple.dart';
import 'package:musiccu/features/musiccu/controllers/selection_controller.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/playlists_controller.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class PlayListTile extends StatelessWidget {
  const PlayListTile({
    super.key,
    required this.playlist,
    this.onTap,
    this.onLongPress,
    this.icon,
    this.color,
  });

  final PlaylistModel playlist;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Icon? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final playlistController = PlaylistController.instance;

    return Obx(() {
      final playlistSongs = playlistController.getFirstTwoSongs(playlist);
      final hasSongs = playlistSongs.isNotEmpty;

      final firstSong = hasSongs ? playlistSongs[0] : null;
      final secondSong = playlistSongs.length > 1 ? playlistSongs[1] : null;

      final coverImage = (playlist.coverImagePath != null && playlist.coverImagePath!.isNotEmpty)
          ? playlist.coverImagePath!
          : (firstSong?.imagePath ?? "");

      return GestureDetector(
        onLongPress:
            onLongPress ??
            () {
              // Ensure the controller is created first
              if (!Get.isRegistered<SelectionController<PlaylistModel>>()) {
                Get.put(SelectionController<PlaylistModel>());
              }
              final playlistSelectionController =
                  Get.find<SelectionController<PlaylistModel>>();

              playlistSelectionController
                  .clearSelection(); // Optional: remove previous selection
              playlistSelectionController.toggleSelection(
                playlist.id,
              ); // Pre-select the long-pressed song

              Get.to(
                () => SelectionScreen<PlaylistModel>(
                  items: playlistController.playlists,
                  getId: (playlist) => playlist.id,
                  buildTile:
                      (playlist) => PlayListTile(
                        playlist: playlist,
                        onTap:
                            () => playlistSelectionController.toggleSelection(
                              playlist.id,
                            ),
                        onLongPress: () {},
                        color:
                            playlistSelectionController.isSelected(playlist.id)
                                ? Colors.blue.withOpacity(0.0)
                                : null,
                      ),
                  padding: 0,
                  selectionController: playlistSelectionController,
                  distance: 0,
                  color:
                      dark
                          ? const Color.fromARGB(255, 31, 30, 30)
                          : AColors.songTitleColor,
                  selectionColor: Colors.blue.withOpacity(0.2),
                  actions: [
                    SelectionAction(
                      icon: Icons.playlist_add,
                      label: 'Add to playlist',
                      onPressed: () {
                        if (!Get.isRegistered<
                          SelectionController<SongModel>
                        >()) {
                          Get.put(SelectionController<SongModel>());
                        }
                        final songSelectionController =
                            Get.find<SelectionController<SongModel>>();

                        songSelectionController.showReplacementView(
                          BottomBarButton(
                            context: context,
                            onTap: () async {
                              await playlistSelectionController.addSongsToMultiplePlaylists(songSelectionController);
                            },
                            color: Colors.blue,
                            text: "Add",
                            selectionController: songSelectionController,
                          ),
                        );

                        Get.to(
                          () => SelectionScreen<SongModel>(
                            items: SongController.instance.songs,
                            getId: (song) => song.id,
                            buildTile: (song) => SongtileSimple(song: song),
                            selectionController: songSelectionController,
                            showSearch: true,
                            onGetBack: () {
                              songSelectionController.clearSelection();
                              Get.back();
                            },
                            actions: [],
                          ),
                        );
                      },
                    ),
                    SelectionAction(
                      icon: Icons.queue_music,
                      label: 'Play next',
                      onPressed: () {},
                    ),
                    SelectionAction(
                      icon: Icons.delete,
                      label: 'Delete',
                      onPressed: () {
                        playlistSelectionController.showReplacementView(
                                    BottomBarButton(
                                      context: context,
                                      onTap: () {
                                        SelectionUI.showDeletePlaylistsDialog(
                                          context,
                                        );
                                      },
                                      selectionController: playlistSelectionController,
                                    ),
                                  );
                      },
                    ),
                  ],
                ),
              );
            },
        onTap:
            onTap ??
            () {
              playlistController.updatePlaylist(playlist, firstSong?.imagePath ?? "", navigate: true);                  
            },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  color ??
                  (dark
                      ? const Color.fromARGB(255, 31, 30, 30)
                      : AColors.songTitleColor),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image - Use first song's image or default
                RoundedImage(
                  imageUrl: coverImage,
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
                          icon != null
                              ? Icon(
                                  icon!.icon,
                                  color: icon!.color ?? (dark ? AColors.songTitleColor : AColors.dark),
                                  size: 20,
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(width: 4),
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
    });
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
