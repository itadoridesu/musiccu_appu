import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/playlists_controller.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/musiccu/screens/playlists/playlists_screen.dart';
import 'package:musiccu/utils/popups/loader.dart';

class SelectionController<T> extends GetxController {
  RxSet<String> selectedIds = <String>{}.obs;

  final Rx<Widget?> replacementView = Rx<Widget?>(
    null,
  ); // Make sure this is reactive

  final playlistController =
      Get.isRegistered<PlaylistController>()
          ? PlaylistController.instance
          : Get.put(PlaylistController());

  final predifinedPlaylistsController = PredefinedPlaylistsController.instance;

  // Toggle selection for an ID
  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  // Check if selected
  bool isSelected(String id) => selectedIds.contains(id);

  // Clear all selections
  void clearSelection() {
    selectedIds.clear();
  }

  // Select all from a list of IDs
  void selectAll(List<String> ids) {
    selectedIds.addAll(ids);
  }

  // Uses your provided methods exactly as specified
  void addSelectedToPlaylist(String playlistId) {
    if (selectedIds.isEmpty) return;
    playlistController.addSongsToPlaylist(playlistId, selectedIds.toList());
    clearSelection();
  }

  Future<void> addSongsToMultiplePlaylists(
    SelectionController<SongModel> songSelectionController,
  ) async {
    if (selectedIds.isEmpty || songSelectionController.selectedIds.isEmpty)
      return;

    try {
      // Show loading indicator

      final playlistIds = selectedIds.toList();

      final songIds = songSelectionController.selectedIds.toList();

      // Add to all playlists except last one (suppress success messages)
      for (int i = 0; i < playlistIds.length; i++) {
        await playlistController.addSongsToPlaylist(
          playlistIds[i],
          songIds,
          showSnackBar: false, // No snackbar for intermediate playlists
          thorwUniqueSongs: false,
        );
      }

      songSelectionController.clearSelection();

      clearSelection();

      Get.back();
      Get.back();

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Songs added to selected playlists successfully.',
      );
    } catch (e) {
      // Close loading if still open

      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to add songs to some playlists: ${e.toString()}',
      );
    }
  }

  /// deleting playlists
  // In SelectionController<PlaylistModel>
  Future<void> deleteSelectedPlaylists() async {
    if (selectedIds.isEmpty) return;

    try {
      await playlistController.deleteMultiplePlaylists(selectedIds.toList());

      clearSelection();

      // Show success message
      TLoaders.successSnackBar(
        title:
            selectedIds.length > 1 ? 'Playlists deleted' : 'Playlist deleted',
        message:
            selectedIds.length > 1
                ? '${selectedIds.length} playlists were removed'
                : 'Playlist was removed successfully',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error :(', message: '${e.toString()}');
    }
  }

  void addSelectedToFavorites() {
    if (selectedIds.isEmpty) return;
    predifinedPlaylistsController.addMultipleToFavorites(selectedIds.toList());
    clearSelection();
  }

  void deleteSelectedSongsPlaylist() {
    final isFavorites =
        playlistController.selectedPlaylist.value?.id ==
        PredefinedPlaylistsController.favoritesId;

    if (isFavorites) {
      predifinedPlaylistsController.removeMultipleFromFavorites(
        selectedIds.toList(),
      );
    } else {
      playlistController.removeSelectedSongs(selectedIds.toList());
    }

    clearSelection();
    restoreDefaultView();
  }

  Future<void> deleteSelectedSongs() async {
    // Delete from main songs list
    await SongController.instance.deleteMultipleSongs(selectedIds.toList());

    // Remove from current playlist (if in playlist context)

    playlistController.removeSelectedSongs(
      selectedIds.toList(),
      usualCall: false,
    );

    PredefinedPlaylistsController.instance.removeFromPredefinedPlaylists(
      selectedIds.toList(),
    );

    clearSelection();
    restoreDefaultView();
  }

  void showReplacementView(Widget view) {
    replacementView.value = view;
  }

  void restoreDefaultView() {
    replacementView.value = null;
  }
}
