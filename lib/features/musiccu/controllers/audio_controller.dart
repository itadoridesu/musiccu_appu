import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart'; // Import the SongController

class AudioController extends GetxController {
  static AudioController get instance => Get.find();

  final AudioPlayer _audioPlayer = AudioPlayer();
  var isPlaying = false.obs;
  var isLoading = false.obs;
  var currentSong = Rxn<SongModel>();
  final SongController songController = SongController.instance;

  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final Rx<Duration> sliderPosition = Duration.zero.obs;
  final RxBool isDragging = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      isPlaying.value = playerState.playing;
    });

    _audioPlayer.positionStream.listen((pos) {
      currentPosition.value = pos;
      
      // Update slider position only when not dragging
      if (!isDragging.value) {
        sliderPosition.value = pos;
      }
    });


    _audioPlayer.durationStream.listen((dur) {
      if (dur != null) totalDuration.value = dur;
    });

    ever(songController.selectedSong, (song) {
      currentSong.value = song;
      if (song != null) {
        playSong();
      } else {
        _audioPlayer.stop();
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

    // Called when user starts dragging
  void startDragging(Duration initialPosition) {
    isDragging.value = true;
    sliderPosition.value = initialPosition;
  }

  // Called while dragging (updates UI only)
  void updateSliderPosition(Duration position) {
    sliderPosition.value = position;
  }


  // Called when dragging ends
  void stopDragging() {
    isDragging.value = false;
  }

  // Seek to the new position
  // This will be called when the user releases the slider
  void seekToPosition(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
