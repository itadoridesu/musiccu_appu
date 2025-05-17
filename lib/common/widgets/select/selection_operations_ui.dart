import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/container/bottomBarButton.dart';
import 'package:musiccu/common/widgets/select/select_screen.dart';
import 'package:musiccu/common/widgets/tiles/playlist_tile_simple.dart';
import 'package:musiccu/common/widgets/tiles/songtile_simple.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/playlists_controller.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/selection_controller.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class SelectionUI {
  static void showBulkAddToPlaylistSheet(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final backgroundColor = dark ? AColors.dark : AColors.pageTitleColor;

    final selectionController = Get.find<SelectionController<SongModel>>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add to Playlist',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    final playlists = PlaylistController.instance.playlists;
                    final favorites =
                        PredefinedPlaylistsController.instance.favorites.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: playlists.length + 2,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                leading: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color:
                                        dark
                                            ? AColors.artistTextColorDark
                                            : const Color.fromARGB(
                                              255,
                                              190,
                                              192,
                                              197,
                                            ),
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 50,
                                    color:
                                        dark
                                            ? AColors.artistTextColor
                                            : AColors.inverseDarkGrey,
                                  ),
                                ),
                                title: const Text('Add New Playlist'),
                                onTap: () {
                                  PlaylistController.instance
                                      .showCreatePlaylistDialog();
                                },
                              ),
                            );
                          } else if (index == 1) {
                            return PlaylistTileSimple(
                              playlist: favorites,
                              onTap: () {
                                Get.back();
                                selectionController.addSelectedToFavorites();
                              },
                            );
                          } else {
                            final playlist = playlists[index - 2];
                            return PlaylistTileSimple(
                              playlist: playlist,
                              onTap: () {
                                Get.back();
                                selectionController.addSelectedToPlaylist(
                                  playlist.id,
                                );
                              },
                            );
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
    );
  }

  static void showDeleteDialog(BuildContext context, String playlistName) {
    final selectionController = Get.find<SelectionController<SongModel>>();
    final dark = THelperFunctions.isDarkMode(context);
    final backgroundColor = dark ? AColors.dark : AColors.pageTitleColor;

    Get.dialog(
      AlertDialog(
        backgroundColor: backgroundColor,
        title: Text(
          'Delete Songs',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: Text(
          'Are you sure you want to delete ${selectionController.selectedIds.length} songs from "$playlistName" playlist?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(fontSize: 16)),
          ),
          TextButton(
            onPressed: () {
              selectionController
                  .deleteSelectedSongsPlaylist(); // Perform deletion
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showDeletePlaylistsDialog(BuildContext context) {
    final selectionController = Get.find<SelectionController<PlaylistModel>>();
    final dark = THelperFunctions.isDarkMode(context);
    final backgroundColor = dark ? AColors.dark : AColors.pageTitleColor;
    final count = selectionController.selectedIds.length;
    final isSingle = count == 1;

    Get.dialog(
      AlertDialog(
        backgroundColor: backgroundColor,
        title: Text(
          isSingle ? 'Delete Playlist' : 'Delete Playlists',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: Text(
          isSingle
              ? 'This will permanently delete the selected playlist.'
              : 'This will permanently delete $count playlists.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              // Just trigger the controller's deletion logic
              selectionController.deleteSelectedPlaylists();
              Get.back(); // Close dialog
              Get.back(); // Close selection screen if needed
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // NEW VERSION - for complete song deletion
  static void showCompleteDeletionDialog(BuildContext context) {
    final selectionController = Get.find<SelectionController<SongModel>>();
    final dark = THelperFunctions.isDarkMode(context);
    final backgroundColor = dark ? AColors.dark : AColors.pageTitleColor;

    Get.dialog(
      AlertDialog(
        backgroundColor: backgroundColor,
        title: Text(
          'Delete Songs',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: Text(
          'This will COMPLETELY delete ${selectionController.selectedIds.length} songs from the Musiccu.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(fontSize: 16)),
          ),
          TextButton(
            onPressed: () {
              selectionController.deleteSelectedSongs();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },

            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
