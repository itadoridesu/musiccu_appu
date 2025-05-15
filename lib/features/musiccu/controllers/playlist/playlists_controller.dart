import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/data/repositories/playlists_repository.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/musiccu/screens/playlists/inside_playlist/inside_playlist.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';
import 'package:musiccu/utils/popups/loader.dart';

class PlaylistController extends GetxController {
  static PlaylistController get instance => Get.find();

  final _playlistRepo = PlaylistRepository.instance;

  // Reactive state
  final RxList<PlaylistModel> playlists = <PlaylistModel>[].obs;

  final selectedPlaylist = Rxn<PlaylistModel>();

  final playlistSongs = Rxn<List<SongModel>>();

  final RxBool shouldNavigateToPlaylist = false.obs;

  final RxBool isLoading = false.obs;

  final songs = SongController.instance.songs;

  // the song id that called the playlist bottom sheet

  @override
  void onInit() {
    super.onInit();
    loadPlaylists();
    _handlePlaylistNavigation();
  }

  Future<void> loadPlaylists() async {
    try {
      final loadedPlaylists = await _playlistRepo.getAllPlaylists();

      final userPlaylists =
          loadedPlaylists.where((playlist) {
            return playlist.id != 'predef_favorites' &&
                playlist.id != 'predef_most_played' &&
                playlist.id != 'predef_recently_played';
          }).toList();

      playlists.assignAll(userPlaylists);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load playlists. Please try again.',
      );
      playlists.clear();
    }
  }

  // Add this to your PlaylistController class
  Future<void> deleteAllPlaylists() async {
    try {
      await _playlistRepo.deleteAllPlaylists();
      playlists.clear();
      TLoaders.successSnackBar(title: "Yes", message: "playlists deleted");
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to delete playlists: ${e.toString()}',
      );
      rethrow;
    }
  }

  // fetch songs for playlist
  void fetchSongsOfSelectedPlaylist() {
    try {
      final playlist = selectedPlaylist.value;
      if (playlist == null) return;

      // Filter all songs to find the ones that match IDs in the playlist
      playlistSongs.value =
          songs.where((song) => playlist.songIds.contains(song.id)).toList();

      playlistSongs.refresh();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Could not load songs for playlist: ${e.toString()}',
      );
    }
  }

  Future<void> addPlaylist(String playlistName) async {
    try {
      final playlist = await PlaylistModel.createNewPlaylist(playlistName);
      await _playlistRepo.addPlaylist(playlist);

      // Add to the beginning of the list instead of the end
      playlists.insert(0, playlist);

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Playlist added successfully!',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to add playlist: ${e.toString()}',
      );
    }
  }

  RxList<SongModel> getFirstTwoSongs(PlaylistModel playlist) {
    final result = <SongModel>[].obs;
    try {
      for (final id in playlist.songIds) {
        final match = songs.firstWhereOrNull((s) => s.id == id);
        if (match != null) result.add(match);
        if (result.length == 2) break;
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Oh Snap!',
        message: 'An error has occured :( }',
      );
    }
    return result;
  }

  // add songs to playlist
  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    try {
      await _playlistRepo.addSongToPlaylist(playlistId, songId);
      final updatedPlaylist = await _playlistRepo.getPlaylist(playlistId);

      if (updatedPlaylist != null) {
        final index = playlists.indexWhere((p) => p.id == playlistId);
        if (index != -1) {
          playlists[index] = updatedPlaylist;
          playlists.refresh();
        }

        TLoaders.successSnackBar(
          title: 'Success',
          message: 'Song added to playlist!',
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: '${e.toString()}');
    }
  }

  /// add multiple songs to playlist
  Future<void> addSongsToPlaylist(
    String playlistId,
    List<String> songIds,
  ) async {
    try {
      isLoading(true);

      // Bulk add to repository
      await _playlistRepo.addSongsToPlaylist(playlistId, songIds);

      // Get updated playlist
      final updatedPlaylist = await _playlistRepo.getPlaylist(playlistId);

      if (updatedPlaylist != null) {
        // Update local state
        final index = playlists.indexWhere((p) => p.id == playlistId);
        if (index != -1) {
          playlists[index] = updatedPlaylist;
          playlists.refresh();
        }

        // If currently viewing this playlist, refresh its songs
        if (selectedPlaylist.value?.id == playlistId) {
          fetchSongsOfSelectedPlaylist();
        }

        TLoaders.successSnackBar(
          title: 'Success',
          message: 'songs added to playlist successfully',
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to add songs: ${e.toString()}',
      );
    } finally {
      isLoading(false);
    }
  }

  // delete songs from playlist
  // In PlaylistController
  Future<void> removeSelectedSongs(List<String> songIds, {bool usualCall = true}) async {
    try {
      final playlist = selectedPlaylist.value!; // Guaranteed to exist
      final updatedSongs =
          playlist.songIds.where((id) => !songIds.contains(id)).toList();

      final updated = playlist.copyWith(songIds: updatedSongs);
      await _playlistRepo.updatePlaylist(updated);

      // Update state
      playlists[playlists.indexWhere((p) => p.id == playlist.id)] = updated;
      selectedPlaylist.value = updated;
      playlists.refresh();
      fetchSongsOfSelectedPlaylist();

      if (usualCall) TLoaders.successSnackBar(
        title: 'Songs removed',
        message:
            '${songIds.length} song${songIds.length > 1 ? 's' : ''} deleted',
      );
    } catch (e) {
      if(usualCall) TLoaders.errorSnackBar(
        title: 'Deletion failed',
        message: 'Please try again',
      );
      rethrow;
    }
  }

  void _handlePlaylistNavigation() {
    ever(shouldNavigateToPlaylist, (shouldNavigate) {
      if (shouldNavigate && selectedPlaylist.value != null) {
        shouldNavigateToPlaylist.value = false;
        fetchSongsOfSelectedPlaylist();
        Get.to(() => InsidePlaylist(playlist: selectedPlaylist.value!));
      }
    });
  }

  void updatePlaylist(PlaylistModel playlist, {bool navigate = false}) {
    selectedPlaylist.value = playlist;
    shouldNavigateToPlaylist.value = navigate;
  }

  /// UI
  void showCreatePlaylistDialog() {
    final TextEditingController playlistNameController =
        TextEditingController();
    final dark = THelperFunctions.isDarkMode(Get.context!);
    final textNotEmpty = false.obs;

    // 🔥 Add a listener to update `textNotEmpty`
    playlistNameController.addListener(() {
      textNotEmpty.value = playlistNameController.text.trim().isNotEmpty;
    });

    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dark ? AColors.darkGray2 : AColors.inverseDarkGrey,
          title: Text('Add New Playlist'),
          titleTextStyle: Theme.of(context).textTheme.headlineSmall,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                return TextField(
                  controller: playlistNameController,
                  decoration: InputDecoration(
                    hintText: 'Playlist Name',
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AColors.primary),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            textNotEmpty.value ? AColors.primary : Colors.grey,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(fontSize: 14)),
            ),
            Obx(
              () => GestureDetector(
                onTap:
                    textNotEmpty.value
                        ? () {
                          Get.back();
                          addPlaylist(playlistNameController.text.trim());
                        }
                        : null,
                child: Text(
                  'Create',
                  style: TextStyle(
                    color: textNotEmpty.value ? AColors.primary : Colors.grey,
                    fontWeight:
                        textNotEmpty.value
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // playlist bottom sheet options + it uesses the current playslut defined here
  void showPlaylistOptions(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final textColor = dark ? AColors.darkGray2 : AColors.inverseDarkGrey;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: dark ? AColors.darkGray2 : AColors.inverseDarkGrey,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add songs to playlist
              ListTile(
                leading: Icon(Icons.add, color: textColor),
                title: Text(
                  'Add Songs',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(fontSize: 18),
                ),
                onTap: () => _handleAddSongs(),
              ),

              // manage playlist
              ListTile(
                leading: Icon(Icons.check_circle_outline, color: textColor),
                title: Text(
                  'Manage Playlist',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(fontSize: 18),
                ),
                onTap: () => _handleManagePlaylist(),
              ),

              // delete playlist
              ListTile(
                leading: Icon(CupertinoIcons.trash, color: textColor),
                title: Text(
                  'Delete Playlist',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(fontSize: 18),
                ),
                onTap: () => _handleDeletePlaylist(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleAddSongs() {
    Get.back(); // Implement song addition logic
  }

  void _handleManagePlaylist() {
    Get.back(); // Implement playlist management
  }

  void _handleDeletePlaylist() {
    Get.back(); // Implement playlist deletion
  }
}
