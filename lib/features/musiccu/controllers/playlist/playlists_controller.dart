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
    if(playlist.coverImagePath == null) selectedPlaylist.value!.coverImagePath = firstSongImage;
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
            // Add songs option
            _buildCompactOption(
              context,
              icon: Icons.add,
              title: 'Add Songs',
              color: textColor,
              onTap: _handleAddSongs,
              radius: 12
            ),
            
            // Manage playlist option (with different icon)
            _buildCompactOption(
              context,
              icon: Icons.playlist_add_check,
              title: 'Manage Playlist',
              color: textColor,
              onTap: _handleManagePlaylist,
              radius: 0
            ),
            
            // Delete option
            _buildCompactOption(
              context,
              icon: Icons.delete_outline,
              title: 'Delete Playlist',
              color: Colors.redAccent,
              onTap: _handleDeletePlaylist,
              radius: 12
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
  required double radius
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: title == 'Add Songs'
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
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    ),
  );
}

  void _handleAddSongs() {
  }

  void _handleManagePlaylist() {
  }

  void _handleDeletePlaylist() {
  }
}
