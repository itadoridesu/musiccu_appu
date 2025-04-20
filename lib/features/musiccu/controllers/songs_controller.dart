import 'package:get/get.dart';
import 'package:musiccu/data/repositories/songs_repository.dart';
import 'package:musiccu/features/musiccu/models/song_model.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/now_playing.dart';
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

      TLoaders.successSnackBar(
        title: 'Songs Loaded',
        message: 'Your songs were loaded successfully',
      );
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
