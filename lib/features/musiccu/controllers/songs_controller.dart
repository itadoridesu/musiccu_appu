import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/common/widgets/texts/moving_text.dart';
import 'package:musiccu/common/widgets/tiles/playlist_tile_simple.dart';
import 'package:musiccu/common/widgets/tiles/text_icon.dart';
import 'package:musiccu/data/repositories/songs_repository.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/playlists_controller.dart';
import 'package:musiccu/features/musiccu/controllers/que_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/now_playing.dart';
import 'package:musiccu/features/personlization/controllers/theme_controller.dart';
import 'package:musiccu/features/personlization/screens/update_song/edit_song_screen.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';
import 'package:musiccu/utils/popups/loader.dart';

class SongController extends GetxController {
  static SongController get instance => Get.find();

  // Reactive state
  final RxList<SongModel> songs = <SongModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<SongModel?> selectedSong = Rx<SongModel?>(
    null,
  ); // Track the selected song
  final RxBool shouldNavigate = false.obs;

  final RxBool lyricsClicked = false.obs;

  // Dependencies
  final SongRepository _songRepository = Get.put(SongRepository());

  late final _playlistController = PlaylistController.instance;

  late final _predefinedPlaylistsController =
      PredefinedPlaylistsController.instance;

  @override
  void onInit() {
    super.onInit();
    loadSongsFromHive();
    // _handleNavigation();
  }

  Future<void> loadSongsFromHive() async {
    try {
      isLoading.value = true;

      final fetchedSongs = await _songRepository.getSongsFromHive();

      songs.assignAll(fetchedSongs);
    } catch (e) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> deleteAll() async {
    try {
      await _songRepository
          .clearAllSongsFromHive(); // Clear all songs from Hive
      songs.value = await _songRepository.getSongsFromHive();

      // On success, show success snack bar
      TLoaders.successSnackBar(
        title: 'Songs Cleared',
        message: 'All songs have been cleared successfully.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> importSongsFromFile() async {
    try {
      isLoading.value = true;

      // Fetch songs from file picker and save to Hive
      await _songRepository.pickAndSaveSongs(); // Picks + saves

      songs.value =
          await _songRepository
              .getSongsFromHive(); // Fetch updated songs from Hive

      TLoaders.successSnackBar(
        title: 'Songs Imported',
        message: 'Your songs were imported successfully desu',
      );
    } catch (e) {
      isLoading.value = false;

      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// delete single song
  Future<void> deleteSong(SongModel song) async {
    try {
      isLoading.value = true;

      await _songRepository.deleteSong(song.id); // Delete from Hive

      songs.value =
          await _songRepository
              .getSongsFromHive(); // Fetch updated songs from Hive

      if (selectedSong.value == song) {
        selectedSong.value = null;
      }

      TLoaders.successSnackBar(
        duration: 2,
        title: 'Song Deleted',
        message: 'Your song was deleted successfully desu',
        horizontalMargin: 20,
        backgroundColor: Colors.red,
        position: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading.value = false;

      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Add this to your SongController
  Future<void> deleteMultipleSongs(List<String> songIds) async {
    try {
      isLoading.value = true;

      // Delete all selected songs from Hive
      await _songRepository.deleteMultipleSongs(songIds);

      // Refresh songs list
      songs.value = await _songRepository.getSongsFromHive();

      // Clear selected song if it was deleted
      if (selectedSong.value != null &&
          songIds.contains(selectedSong.value!.id)) {
        selectedSong.value = null;
      }

      TLoaders.successSnackBar(
        title: 'Deleted ${songIds.length} songs',
        message: 'Songs removed successfully',
        backgroundColor: Colors.redAccent,
      );
      isLoading.value = false;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
      isLoading.value = false;
    }
  }

  Future<void> updateSong(SongModel updatedSong) async {
    try {
      final index = songs.indexWhere((s) => s.id == updatedSong.id);
      if (index == -1) throw Exception('Song not found.');

      await _songRepository.updateSong(updatedSong);

      songs[index] = updatedSong;
      songs.refresh();

      if (selectedSong.value?.id == updatedSong.id) {
        // Update fields manually without changing the instance
        selectedSong.value!.songName = updatedSong.songName;
        selectedSong.value!.artistName = updatedSong.artistName;
        selectedSong.value!.albumName = updatedSong.albumName;
        selectedSong.value!.imagePath = updatedSong.imagePath;

        selectedSong.refresh();
      }
    } catch (e) {
      rethrow;
    }
  }

  void updateSelectedSong(
    SongModel song, {
    bool navigate = false,
    BuildContext? context,
  }) {
    // Same song - just open NowPlaying
    if (selectedSong.value?.id == song.id) {
      Get.to(
        () => NowPlayingNoLyrics(showIcon: false),
        duration: const Duration(milliseconds: 600),
      );
      return;
    }

    // New song selected
    selectedSong.value = song;

    _predefinedPlaylistsController.addToRecentlyPlayed(song.id);

    if (context != null) {
      // Get the route where we're selecting from
      final modalRoute = ModalRoute.of(context);

      // Pop until we reach the original screen
      Navigator.popUntil(context, (route) {
        // This pops past any NowPlaying/Lyrics screens
        return route == modalRoute;
      });

      // Then push new NowPlaying
      Get.to(
        () => NowPlayingNoLyrics(showIcon: false),
        duration: const Duration(milliseconds: 600),
      );
    } else {
      // Fallback without context
      Get.offUntil(
        GetPageRoute(
          page: () => NowPlayingNoLyrics(showIcon: false),
          transitionDuration: const Duration(milliseconds: 600),
        ),
        (route) => route.isFirst,
      );
    }
  }

  /// Ui calling methods

  void showSongMenu(SongModel song, BuildContext context, int index) {
    final dark = ThemeController.instance.isDarkMode.value;
    final backgroundColor = dark ? AColors.dark : AColors.pageTitleColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Song details
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                clipBehavior:
                    Clip.antiAlias, // required for ripple to clip to radius
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    updateSelectedSong(song, navigate: true);
                    QueueController.instance.setQueue(
                      songs,
                      startingIndex: index,
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Song image
                      song == selectedSong.value
                          ? RoundedImage(
                            imageUrl: song.imagePath,
                            height: 50,
                            width: 50,
                            applyImageRadius: true,
                            rotate: true,
                          )
                          : RoundedImage(
                            imageUrl: song.imagePath,
                            height: 50,
                            width: 50,
                            applyImageRadius: true,
                            borderRadius: 15,
                            rotate: false,
                          ),
                      const SizedBox(width: 7),
                      // Song name and artist
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          song == selectedSong.value
                              ? MovingText(
                                text: song.songName,
                                height: 30,
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                width: 150,
                              )
                              : SizedBox(
                                width: 160,
                                child: Text(
                                  song.songName,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          SizedBox(
                            width: 160,
                            child: Text(
                              song.artistName,
                              style: Theme.of(context).textTheme.labelMedium!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                '${(THelperFunctions.formatFileSize(song.fileSize))}',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.copyWith(color: Colors.grey),
              ),
              const Divider(),
              // Menu options
              TextIcon(
                text: 'Edit',
                icon: Icons.edit,
                onPressed: () {
                  Navigator.pop(context);
                  Get.to(() => EditSongScreen(song: song));
                },
              ),
              TextIcon(
                text: 'Add to Playlist',
                icon: Icons.playlist_add,
                onPressed: () {
                  Navigator.pop(context);
                  showPlaylistBottomSheet(context, song.id);
                },
              ),
              TextIcon(
                text: 'Delete',
                icon: Icons.delete,
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                  showDeleteDialogue(context, song);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showDeleteDialogue(BuildContext context, SongModel song) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final dark = ThemeController.instance.isDarkMode.value;
        final backgroundColor = dark ? AColors.dark : AColors.pageTitleColor;

        return AlertDialog(
          backgroundColor: backgroundColor,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 55,
          ), // ⬅️ Makes dialog smaller
          title: Row(
            children: [
              RoundedImage(
                imageUrl: song.imagePath,
                height: 50,
                width: 50,
                applyImageRadius: true,
                borderRadius: 15,
              ),
              const SizedBox(width: 10),
              Text(
                'Delete Song',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this song?',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w400),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel dialog
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation
                deleteSong(song); // Perform delete
                PredefinedPlaylistsController.instance
                    .removeFromPredefinedPlaylists([song.id]);
              },
              child: Text(
                'Delete',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showPlaylistBottomSheet(BuildContext context, String songId) {
    if (!Get.isRegistered<PlaylistController>()) {
      Get.put(PlaylistController());
    }
    final dark = THelperFunctions.isDarkMode(context);
    final backgroundColor = dark ? AColors.dark : AColors.pageTitleColor;

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
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    final playlists = _playlistController.playlists;

                    // Get favorites image path (first favorite song or fallback)

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount:
                            playlists.length +
                            2, // +1 for Add, +1 for Favorites
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
                                  _playlistController
                                      .showCreatePlaylistDialog();
                                },
                              ),
                            );
                          } else if (index == 1) {
                            return PlaylistTileSimple(
                              playlist:
                                  _predefinedPlaylistsController
                                      .favorites
                                      .value,
                              onTap: () {
                                Get.back();
                                _predefinedPlaylistsController.toggleFavorite(
                                  songId,
                                  usualToggle: false,
                                );
                              },
                            );
                          } else {
                            final playlist =
                                playlists[index - 2]; // offset by 2
                            return PlaylistTileSimple(
                              playlist: playlist,
                              onTap: () {
                                Get.back();
                                _playlistController.addSongToPlaylist(
                                  playlist.id,
                                  songId,
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
}
