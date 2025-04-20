import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiccu/features/musiccu/models/song_model.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';  // Import the SongController

class AudioController extends GetxController {
  static AudioController get instance => Get.find();

  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var currentSong = Rxn<SongModel>();
  final SongController songController = SongController.instance;

  @override
  void onInit() {
    super.onInit();
    
    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      isPlaying.value = playerState.playing;
    });
    
    ever(songController.selectedSong, (song) {
      currentSong.value = song;
      if (song != null) {
        playSong();
      }
    });
  }

  Future<void> togglePlayPause() async {
    if (currentSong.value == null) return;

    if (isPlaying.value) {
      await _audioPlayer.pause();
    } else {
      // If player is not initialized, set it up first
      if (_audioPlayer.processingState == ProcessingState.idle) {
        await _setupPlayer();
      }
      await _audioPlayer.play();
    }
    // Note: We don't manually set isPlaying here - the stream listener will handle it
  }

  Future<void> playSong() async {
    if (currentSong.value == null) return;

    try {
      isLoading.value = true;
      await _setupPlayer();
      await _audioPlayer.play();
      // isPlaying will be updated by the stream listener
    } catch (e) {
      print("Error loading song: $e");
      isPlaying.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _setupPlayer() async {
    if (currentSong.value == null) return;

    try {
      await _audioPlayer.setFilePath(currentSong.value!.audioUrl);
      
    } catch (e) {
      rethrow;
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}