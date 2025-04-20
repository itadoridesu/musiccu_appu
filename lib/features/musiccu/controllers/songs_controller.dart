import 'package:get/get.dart';
import 'package:musiccu/data/repositories/songs_repository.dart';
import 'package:musiccu/features/musiccu/models/song_model.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/now_playing.dart';

class SongController extends GetxController {
  static SongController get instance => Get.find();

  // Reactive state
  final RxList<SongModel> songs = <SongModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final Rx<SongModel?> selectedSong = Rx<SongModel?>(null); // Track the selected song
  final RxBool shouldNavigate = false.obs;

  // Dependencies
  final SongRepository _songRepository = Get.put(SongRepository());

  @override
  void onInit() {
    super.onInit();
      print('🧠 CONTROLLER INIT TRIGGERED!');

    loadSongsFromHive(); // Automatically load songs from Hive when the controller initializes
    _handleNavigation();
  }

  Future<void> loadSongsFromHive() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Debug: Print when songs are loading from Hive
      print('📥 COMING FROM SongController - Loading songs from Hive...'); 

      final fetchedSongs = await _songRepository.getSongsFromHive();

      // Debug: Print fetched songs
      print('🎶 COMING FROM SongController - Fetched songs: $fetchedSongs'); 

      songs.assignAll(fetchedSongs); 

      // Debug: Print the updated songs list
      print('🔥 UI SHOULD UPDATE NOW WITH ${songs.length} SONGS');

    } catch (e) {
      errorMessage.value = 'Failed to load songs: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAll() async {
    await _songRepository.clearAllSongsFromHive(); // Clear all songs from Hive
    songs.value = await _songRepository.getSongsFromHive();
  }

  Future<void> importSongsFromFile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Debug: Print when importing songs from file
      print('📂 COMING FROM SongController - Importing songs from file...');

      // Fetch songs from file picker and save to Hive
      await _songRepository.pickAndSaveSongs(); // Picks + saves

      // Debug: Print confirmation of songs being saved
      print('🎵 COMING FROM SongController - Songs imported and saved to Hive');

      await loadSongsFromHive(); // Refresh the local list from Hive
    } catch (e) {
      errorMessage.value = 'Failed to import songs: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void updateSelectedSong(SongModel song, {bool navigate = false}) {
    selectedSong.value = song;
    shouldNavigate.value = navigate; // <- flag to trigger nav

    // Debug: Print selected song and navigation flag
    print('🎧 COMING FROM SongController - Selected song: ${song.songName}, navigate: $navigate');
  }

  void _handleNavigation() {
    ever(shouldNavigate, (bool shouldNav) {
      if (shouldNav && selectedSong.value != null) {
        shouldNavigate.value = false; // Reset the trigger

        // Debug: Print when navigation is triggered
        print('🛸 COMING FROM SongController - Navigating to NowPlaying screen for song: ${selectedSong.value!.songName}');

        // Navigate to the NowPlaying screen
        Get.to(
          () => NowPlayingNoLyrics(song: selectedSong.value!, showIcon: false),
          duration: const Duration(milliseconds: 600),
        );
      }
    });
  }
}
