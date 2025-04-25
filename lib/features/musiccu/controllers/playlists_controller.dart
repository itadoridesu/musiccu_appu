import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/data/repositories/playlists_repository.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';
import 'package:musiccu/utils/popups/loader.dart';

class PlaylistController extends GetxController {
  static PlaylistController get instance => Get.find();

  final _playlistRepo = Get.put(PlaylistRepository());
  final RxList<PlaylistModel> playlists = <PlaylistModel>[].obs;
  final RxList<SongModel> playlistSongs = <SongModel>[].obs; // New reactive list for playlist songs
  final Rx<PlaylistModel?> currentPlaylist = Rx<PlaylistModel?>(null); // Track current playlist

  final songs = SongController.instance.songs;



  @override
  void onInit() {
    super.onInit();
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    try {
      
      // Fetch playlists from repository
      final loadedPlaylists = await _playlistRepo.getAllPlaylists();
      
      // Update reactive list
      playlists.assignAll(loadedPlaylists);
    } catch (e) {
      print("THIS IS MY ERRRRRRRRRRRRRRRRRRRRRRRRRRRROOOOOOOOOOOOOOOOOOR: " + e.toString());
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
    playlistSongs.clear();
    currentPlaylist.value = null;
  } catch (e) {
    TLoaders.errorSnackBar(
      title: 'Error',
      message: 'Failed to delete playlists: ${e.toString()}',
    );
    rethrow;
  }
}

    // New method to load songs for a specific playlist
  Future<void> loadPlaylistSongs(String playlistId) async {
    try {
      // Get the playlist
      final playlist = await _playlistRepo.getPlaylist(playlistId);
      if (playlist == null) return;
      
      // Set as current playlist
      currentPlaylist.value = playlist;
      
      // Get all songs from SongController
      final allSongs = songs;
      
      // Filter songs that are in this playlist
      final songsInPlaylist = allSongs.where(
        (song) => playlist.songIds.contains(song.id)
      ).toList();
      
      // Update reactive list
      playlistSongs.assignAll(songsInPlaylist);
      
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load playlist songs. Please try again.',
      );
      playlistSongs.clear();
    }
  }

  Future<void> addPlaylist(String playlistName) async {
    try {

      final playlist = PlaylistModel.createNewPlaylist(playlistName);
      await _playlistRepo.addPlaylist(playlist);
      playlists.add(playlist);

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Playlist added successfully!',
      );

    } catch (e) {
      print("THIS IS THE ERROR I AM GETTING HHHHHHHH" +e.toString());
      TLoaders.errorSnackBar(
        title: 'Error',
         message: 'Failed to add playlist: ${e.toString()}'
      );
    }
  }

  /// UI 
void showCreatePlaylistDialog() {
  final TextEditingController playlistNameController = TextEditingController();
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
                      color: textNotEmpty.value ? AColors.primary : Colors.grey,
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
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Obx(() => GestureDetector(
                onTap: textNotEmpty.value
                    ? () {
                        Get.back();
                        addPlaylist(playlistNameController.text.trim());
                      }
                    : null,
                child: Text(
                  'Create',
                  style: TextStyle(
                    color:
                        textNotEmpty.value ? AColors.primary : Colors.grey,
                    fontWeight: textNotEmpty.value
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              )),
        ],
      );
    },
  );
}

}