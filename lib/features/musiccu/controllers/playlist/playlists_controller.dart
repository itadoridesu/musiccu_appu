import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/container/bottomBarButton.dart';
import 'package:musiccu/common/widgets/select/select_screen.dart';
import 'package:musiccu/common/widgets/tiles/songtile_simple.dart';
import 'package:musiccu/data/repositories/playlists_repository.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/selection_controller.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/musiccu/screens/playlists/inside_playlist/inside_playlist.dart';
import 'package:musiccu/features/musiccu/screens/playlists/playlists_screen.dart';
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

  // fetch songs for playlist
  void fetchSongsOfSelectedPlaylist() {
    try {
      final playlist = selectedPlaylist.value;
      if (playlist == null) return;

      // Filter all songs to find the ones that match IDs in the playlist
      playlistSongs.value =songs.where((song) => playlist.songIds.contains(song.id)).toList();

      if (playlist.id == PredefinedPlaylistsController.mostPlayedId) {
      songs.sort((a, b) => b.playCount.compareTo(a.playCount));
    }

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
      playlists.add(playlist);

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

  /// Add multiple songs to playlist
  Future<void> addSongsToPlaylist(
    String playlistId,
    List<String> songIds, {
    bool showSnackBar = true,
    bool thorwUniqueSongs = true
  }) async {
    try {
      isLoading(true);

      // Bulk add to repository
      await _playlistRepo.addSongsToPlaylist(playlistId, songIds, show: thorwUniqueSongs);

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
          selectedPlaylist.value = updatedPlaylist;
          if(selectedPlaylist.value!.id == "predef_favorites") PredefinedPlaylistsController.instance.favorites.value = updatedPlaylist;
          fetchSongsOfSelectedPlaylist();
        }

        if (showSnackBar) {
          TLoaders.successSnackBar(
            title: 'Success',
            message: 'Songs added to playlist successfully',
          );
        }
      }
    } catch (e) {
      if (showSnackBar) {
        TLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to add songs: ${e.toString()}',
        );
      } else {
        rethrow;
      }
    } finally {
      isLoading(false);
    }
  }

  // adding song to favotire 
  Future<void> addSongToFavorites(String songId) async {
  try {
    await _playlistRepo.addSongToPlaylist("predef_favorites", songId);

    final updatedFavorites = await _playlistRepo.getPlaylist("predef_favorites");
    if (updatedFavorites == null) return;
    
    
    // 3. Update current view if needed
    if (selectedPlaylist.value?.id == "predef_favorites") {
      selectedPlaylist.value = updatedFavorites;
      fetchSongsOfSelectedPlaylist();
    }
    
    playlists.refresh();
  } catch (e) {
    TLoaders.errorSnackBar(
      title: 'Error',
      message: 'Failed to add to favorites',
    );
    rethrow;
  }
}

  // delete song from playlist (only for the favoriting)
Future<void> removeSongFromFavorites(String songId) async {
  try {
    // 1. Update in repository
    await _playlistRepo.removeSongFromPlaylist("predef_favorites", songId);
    
    // 2. Force refresh from repository
    final updatedFavorites = await _playlistRepo.getPlaylist("predef_favorites");
    if (updatedFavorites == null) return;
    
    
    // 3. Update current view if needed
    if (selectedPlaylist.value?.id == "predef_favorites") {
      selectedPlaylist.value = updatedFavorites;
      fetchSongsOfSelectedPlaylist();
    }
    
    playlists.refresh();
  } catch (e) {
    TLoaders.errorSnackBar(
      title: 'Error', 
      message: 'Failed to remove from favorites'
    );
  }
}

  /// delete playlists
  Future<void> deleteMultiplePlaylists(List<String> playlistIds) async {
    if (playlistIds.isEmpty) return;

    try {
      await _playlistRepo.deleteMultiplePlaylists(playlistIds);
      
      playlists.removeWhere((playlist) => playlistIds.contains(playlist.id));

      playlists.refresh();  
      
    } catch (e) {
      rethrow;
    }
  }

  // delete playlist
  Future<void> deletePlaylist() async {
    final playlist = selectedPlaylist.value;
    if (playlist == null) return;
    try {
      await _playlistRepo.deletePlaylist(playlist.id);
      playlists.removeWhere((p) => p.id == playlist.id);
      playlists.refresh();


      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Playlist deleted successfully',
      );

    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to delete playlist: ${e.toString()}',
      );
    }
  }

  // delete songs from playlist
  Future<void> removeSelectedSongs(
    List<String> songIds, {
    bool usualCall = true,
    bool fromFavorites = false
  }) async {
    try {
      final playlist = selectedPlaylist.value!; // Guaranteed to exist
      final updatedSongs =
          playlist.songIds.where((id) => !songIds.contains(id)).toList();

      final updated = playlist.copyWith(songIds: updatedSongs);
      await _playlistRepo.updatePlaylist(updated);

      // Update state
      if(!fromFavorites) playlists[playlists.indexWhere((p) => p.id == playlist.id)] = updated;
      selectedPlaylist.value = updated;
      fetchSongsOfSelectedPlaylist();

      if (usualCall)
        TLoaders.successSnackBar(
          title: 'Songs removed',
          message:
              '${songIds.length} song${songIds.length > 1 ? 's' : ''} deleted',
        );
    } catch (e) {
      if (usualCall)
        TLoaders.errorSnackBar(
          title: 'Deletion failed',
          message: 'Please try again',
        );
      rethrow;
    }
  }

  // in update playlist screen
  Future<void> updatePlaylistFields({
    String? newName,
    String? newCoverImagePath,
  }) async {
    try {
      final updatedPlaylist = selectedPlaylist.value!.copyWith(
        name: newName ?? selectedPlaylist.value!.name,
        coverImagePath: newCoverImagePath ?? selectedPlaylist.value!.coverImagePath,
        updatedAt: DateTime.now(),
        isCoverManuallySet: true
      );

      await _playlistRepo.updatePlaylist(updatedPlaylist);

      final index = playlists.indexWhere((p) => p.id == updatedPlaylist.id);
      playlists[index] = updatedPlaylist;
      selectedPlaylist.value = updatedPlaylist;
      playlists.refresh();
    } catch (e) {
        throw "Failed to update playlist";
    }
  }

  void _handlePlaylistNavigation() {
    ever(shouldNavigateToPlaylist, (shouldNavigate) {
      if (shouldNavigate && selectedPlaylist.value != null) {
        shouldNavigateToPlaylist.value = false;
        fetchSongsOfSelectedPlaylist();
        Get.to(() => InsidePlaylist());
      }
    });
  }

  void updatePlaylist(PlaylistModel playlist, String? firstSongImage ,{bool navigate = false}) {
    selectedPlaylist.value = playlist;
    if(!playlist.isCoverManuallySet) selectedPlaylist.value!.coverImagePath = firstSongImage;
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
              () => TextButton(
                onPressed:
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
                            fontSize: 14
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
    final backgroundColor = dark ? AColors.dark : AColors.white;
    final textColor = dark ? AColors.white : AColors.dark;

    final selectionController = Get.put(SelectionController<SongModel>());


    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: false, // Disable dragging
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Only show "Add Songs" if not a predef_recently_played or predef_most_played playlist
              if (selectedPlaylist.value?.id != 'predef_recently_played' &&
                selectedPlaylist.value?.id != 'predef_most_played')
              _buildCompactOption(
                context,
                icon: Icons.add,
                title: 'Add Songs',
                color: textColor,
                onTap: () {
                _handleAddSongs(selectionController, context);
                },
                radius: 12,
              ),

              // Manage playlist option (always shown)
              _buildCompactOption(
              context,
              icon: Icons.playlist_add_check,
              title: 'Manage Playlist',
              color: textColor,
              onTap: () => Navigator.pop(context),
              radius: 0,
              ),

              // Only show "Delete Playlist" if not a predef playlist
              if (selectedPlaylist.value?.id != 'predef_favorites' &&
                selectedPlaylist.value?.id != 'predef_recently_played' &&
                selectedPlaylist.value?.id != 'predef_most_played')
              _buildCompactOption(
                context,
                icon: Icons.delete_outline,
                title: 'Delete Playlist',
                color: Colors.redAccent,
                onTap: () {
                _handleDeletePlaylist(selectionController, context);
                },
                radius: 12,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required double radius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            title == 'Add Songs'
                ? const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )
                : title == 'Delete Playlist'
                ? const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )
                : BorderRadius.zero,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAddSongs(
    SelectionController<SongModel> selectionController,
    BuildContext context,
  ) {
    selectionController.clearSelection();
    selectionController.showReplacementView(
      BottomBarButton(
        context: context,
        onTap: () {
          selectionController.addSelectedToPlaylist(selectedPlaylist.value!.id);
          Navigator.pop(context); 
          Navigator.pop(context); 
        },
        color: Colors.blue,
        text: "Add",
        selectionController: selectionController,
      ),
    );

    Get.to(
      () => SelectionScreen<SongModel>(
        items: SongController.instance.songs,
        getId: (song) => song.id,
        buildTile: (song) => SongtileSimple(song: song),
        selectionController: selectionController,
        showSearch: true,
        onGetBack: () {
          selectionController.clearSelection();
          Navigator.pop(context);
          Navigator.pop(context);
        },
        actions: [],
      ),
    );
  }

  void _handleManagePlaylist() {}

  void _handleDeletePlaylist(
    SelectionController<SongModel> selectionController,
    BuildContext context,
  ) {
    final playlist = selectedPlaylist.value;
    if (playlist == null) return;

    final dark = THelperFunctions.isDarkMode(context);
    final backgroundColor = dark ? AColors.dark : AColors.pageTitleColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          insetPadding: const EdgeInsets.symmetric(horizontal: 55),
          title: Row(
            children: [
              // Playlist cover image or fallback
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: 
                   Container(
                        height: 50,
                        width: 50,
                        color: Colors.grey[400],
                        child: Icon(Icons.music_note, color: Colors.white, size: 30),
                      ),
              ),
              const SizedBox(width: 10),
              Text(
                'Delete Playlist',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this playlist?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w400),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                await deletePlaylist();
              },
              child: Text(
                'Delete',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
}
