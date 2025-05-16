import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/playlists_controller.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';
import 'package:musiccu/utils/popups/loader.dart';

class EditPlaylistController extends GetxController {
  static EditPlaylistController get instance => Get.find();

  /// Text controllers
  final playlistName = TextEditingController();
  final GlobalKey<FormState> editPlaylistFormKey = GlobalKey<FormState>();

  late PlaylistModel originalPlaylist;
  final RxnString newCoverImagePath = RxnString();

  /// Initialize controller with playlist data
  void init(PlaylistModel playlist) {
    originalPlaylist = playlist;
    playlistName.text = playlist.name;
    newCoverImagePath.value = playlist.coverImagePath;
  }

  /// Let user pick a new cover image
  Future<void> pickNewCoverImage() async {
    final path = await THelperFunctions.pickImagePathFromGallery();
    if (path != null) {
      newCoverImagePath.value = path;
    }
  }

  Future<void> savePlaylistChanges() async {
    try {
      if (!editPlaylistFormKey.currentState!.validate()) return;

      final trimmedName = playlistName.text.trim();

      final isModified =
          trimmedName != originalPlaylist.name ||
          newCoverImagePath.value != originalPlaylist.coverImagePath;

      if (!isModified) {
        TLoaders.customToast(message: 'No modifications were made');
        Get.back();
        return;
      }


      PlaylistController.instance.updatePlaylistFields(newName: trimmedName, newCoverImagePath: newCoverImagePath.value);

      Get.back();

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Playlist updated successfully',
      );
      
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  @override
  void onClose() {
    playlistName.dispose();
    super.onClose();
  }
}