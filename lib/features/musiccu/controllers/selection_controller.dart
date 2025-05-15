import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/playlists_controller.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';

class SelectionController<T> extends GetxController {
  RxSet<String> selectedIds = <String>{}.obs;

  final Rx<Widget?> replacementView = Rx<Widget?>(null); // Make sure this is reactive
  

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

  void addSelectedToFavorites() {
    if (selectedIds.isEmpty) return;
    predifinedPlaylistsController.addMultipleToFavorites(selectedIds.toList());
    clearSelection();
  }

  void deleteSelectedSongsPlaylist() {
    playlistController.removeSelectedSongs(selectedIds.toList());

    clearSelection();
    restoreDefaultView();
  }

  
  Future<void> deleteSelectedSongs() async{  
  // Delete from main songs list
  await SongController.instance.deleteMultipleSongs(selectedIds.toList());
  
  // Remove from current playlist (if in playlist context)
 
  playlistController.removeSelectedSongs(selectedIds.toList(), usualCall: false);

  PredefinedPlaylistsController.instance.removeFromPredefinedPlaylists(selectedIds.toList());

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
