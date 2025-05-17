import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';
import 'package:musiccu/utils/popups/loader.dart';

class EditSongController extends GetxController {
  static EditSongController get instance => Get.find();

  /// Text controllers
  final songName = TextEditingController();
  final artist = TextEditingController();
  final album = TextEditingController();
  final GlobalKey<FormState> editSongFormKey = GlobalKey<FormState>();

  late SongModel originalSong;
  final RxnString newImagePath = RxnString();

  /// Initialize controller with song data
  void init(SongModel song) {
    originalSong = song;
    songName.text = song.songName;
    artist.text = song.artistName;
    album.text = song.albumName;
    newImagePath.value = song.imagePath;
  }

  /// Let user pick a new image
  Future<void> pickNewCoverImage() async {
    final path = await THelperFunctions.pickImagePathFromGallery();
    if (path != null) {
      newImagePath.value = path;
    }
  }

  Future<void> saveSongChanges() async {
    try {
      if (!editSongFormKey.currentState!.validate()) return;

      final trimmedName = songName.text.trim();
      final trimmedArtist = artist.text.trim();
      final trimmedAlbum = album.text.trim();

      final isModified =
          trimmedName != originalSong.songName ||
          trimmedArtist != originalSong.artistName ||
          trimmedAlbum != originalSong.albumName ||
          newImagePath.value != originalSong.imagePath;

      if (!isModified) {
        TLoaders.customToast(message: 'No modifications were made');
        Get.back();
        return;
      }

      final updatedSong = originalSong.copyWith(
        songName: trimmedName,
        artistName: trimmedArtist,
        albumName: trimmedAlbum,
        imagePath: newImagePath.value,
      );

      await SongController.instance.updateSong(updatedSong);

      Get.back();

      TLoaders.successSnackBar(
        title: 'Yaay',
        message: 'Song updated successfully',
      );
      
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  @override
  void onClose() {
    songName.dispose();
    artist.dispose();
    album.dispose();
    super.onClose();
  }
}
