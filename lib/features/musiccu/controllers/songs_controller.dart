import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/common/widgets/texts/moving_text.dart';
import 'package:musiccu/data/repositories/songs_repository.dart';
import 'package:musiccu/features/musiccu/models/song_model.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/now_playing.dart';
import 'package:musiccu/features/personlization/controllers/theme_controller.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';
import 'package:musiccu/utils/popups/loader.dart';


class SongController extends GetxController {
  static SongController get instance => Get.find();

  // Reactive state
  final RxList<SongModel> songs = <SongModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<SongModel?> selectedSong = Rx<SongModel?>(null); // Track the selected song
  final RxBool shouldNavigate = false.obs;

  // Dependencies
  final SongRepository _songRepository = Get.put(SongRepository());

  @override
  void onInit() {
    super.onInit();
    loadSongsFromHive(); 
    _handleNavigation();
  }

  Future<void> loadSongsFromHive() async {
    try {
      isLoading.value = true;

      final fetchedSongs = await _songRepository.getSongsFromHive();

      songs.assignAll(fetchedSongs); 

    } catch (e) {
      isLoading.value = false; 
      TLoaders.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    } 
  }

  // Future<void> deleteAll() async {
  //   try {

  //     await _songRepository.clearAllSongsFromHive(); // Clear all songs from Hive
  //     songs.value = await _songRepository.getSongsFromHive();

  //     // On success, show success snack bar
  //     TLoaders.successSnackBar(
  //       title: 'Songs Cleared',
  //       message: 'All songs have been cleared successfully.',
  //     );
  //   } catch (e) {

  //     TLoaders.errorSnackBar(
  //       title: 'Error',
  //       message: e.toString(),
  //     );
  //   } 
  // }

  Future<void> importSongsFromFile() async {
    try {
      isLoading.value = true;

      // Fetch songs from file picker and save to Hive
      await _songRepository.pickAndSaveSongs(); // Picks + saves

      songs.value = await _songRepository.getSongsFromHive(); // Fetch updated songs from Hive

      TLoaders.successSnackBar(
        title: 'Songs Imported',
        message: 'Your songs were imported successfully desu',
      );

    } catch (e) {
      isLoading.value = false; 

      TLoaders.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  /// delete single song
  Future<void> deleteSong(SongModel song) async {
    try {
      isLoading.value = true;

      

      await _songRepository.deleteSong(song.id); // Delete from Hive

      songs.value = await _songRepository.getSongsFromHive(); // Fetch updated songs from Hive

      if(selectedSong.value == song) {
        selectedSong.value = null; 
      }

      TLoaders.successSnackBar(
        title: 'Song Deleted',
        message: 'Your song was deleted successfully desu',
      );

    } catch (e) {
      isLoading.value = false; 

      TLoaders.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

void showSongMenu(SongModel song, BuildContext context) {
  final dark = ThemeController.instance.isDarkMode.value;
  final textColor = dark ? AColors.songTitleColor : AColors.songTitleColorDark;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Song image
                    RoundedImage(imageUrl: song.imagePath, height: 50, width: 50, applyImageRadius: true, rotate: song == selectedSong.value? true : false,),
                    const SizedBox(width: 7),
                    // Song name and artist
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MovingText(text: song.songName, height: 30, textStyle: Theme.of(context).textTheme.bodyLarge, width: 120),
                        Text(
                          song.artistName,
                          style: Theme.of(context).textTheme.labelMedium!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

                 Text(
                  '${(THelperFunctions.formatFileSize(song.fileSize) )}',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey),
                ),
            const Divider(),

            // Menu options
            ListTile(
              title: Text(
                'Edit',
                style: TextStyle(color: textColor),
              ),
              trailing: Icon(Icons.edit, color: textColor),
              onTap: () {
                // Add your update logic here
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          
            ListTile(
              title: Text(
                'Add to Playlist',
                style: TextStyle(color: textColor),
              ),
              trailing: Icon(Icons.playlist_add, color: textColor),
              onTap: () {
                // Add your logic here
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ListTile(
              title: Text(
                'Delete',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.delete, color: Colors.red),
              onTap: () {
                deleteSong(song); // Call delete function
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    },
  );
}

  void updateSelectedSong(SongModel song, {bool navigate = false}) {
    selectedSong.value = song;
    shouldNavigate.value = navigate; // <- flag to trigger nav
  }

  void _handleNavigation() {
    ever(shouldNavigate, (bool shouldNav) {
      if (shouldNav && selectedSong.value != null) {
        shouldNavigate.value = false; // Reset the trigger

        // Navigate to the NowPlaying screen
        Get.to(
          () => NowPlayingNoLyrics(song: selectedSong.value!, showIcon: false),
          duration: const Duration(milliseconds: 600),
        );
      }
    });
  }
}
