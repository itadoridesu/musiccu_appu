import 'package:get/get.dart';
import 'package:musiccu/features/musiccu/controllers/audio/audio_controller.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/playlists_controller.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';

enum RepeatMode { off, all, one }

class QueueController extends GetxController {
  static QueueController get instance => Get.find();

  // Public reactive state
  RxList<SongModel> queue = <SongModel>[].obs;
  RxInt currentIndex = (-1).obs;
  Rx<RepeatMode> repeatMode = RepeatMode.off.obs;
  RxBool isShuffled = false.obs;

  final songController = SongController.instance;

  late final predefinedPlaylistsController =
      PredefinedPlaylistsController.instance;

  // Add this to your QueueController class

  /// Gets the next two songs based on current repeat mode
  List<SongModel?> get nextTwoSongs {
    if (queue.isEmpty) return [null, null];

    switch (repeatMode.value) {
      case RepeatMode.one:
        // In repeat one mode, it's always the current song
        return [currentSong, currentSong];

      case RepeatMode.all:
        // Circular behavior - wrap around to beginning
        final firstIndex = (currentIndex.value + 1) % queue.length;
        final secondIndex = (currentIndex.value + 2) % queue.length;
        return [queue[firstIndex], queue[secondIndex]];

      case RepeatMode.off:
        // Linear behavior - return null if at end
        final firstIndex = currentIndex.value + 1;
        final secondIndex = currentIndex.value + 2;

        return [
          firstIndex < queue.length ? queue[firstIndex] : null,
          secondIndex < queue.length ? queue[secondIndex] : null,
        ];
    }
  }

  // Original order storage (non-reactive)
  List<SongModel> _originalOrder = [];
  int _originalIndex = 0;

  // Current song getter
  SongModel? get currentSong =>
      (currentIndex.value >= 0 && currentIndex.value < queue.length)
          ? queue[currentIndex.value]
          : null;

  /// Sets new queue with optional starting index
  void setQueue(List<SongModel> songs, {int startingIndex = 0}) {
    if (songs.isEmpty) {
      clearQueue();
      return;
    }

    _originalOrder = List.from(songs);
    _originalIndex = startingIndex;
    queue.assignAll(songs);
    currentIndex.value = startingIndex.clamp(0, songs.length - 1);
    isShuffled.value = false;
  }

  /// Clears the queue completely
  void clearQueue() {
    queue.clear();
    _originalOrder.clear();
    currentIndex.value = -1;
    isShuffled.value = false;
  }

  /// Toggles shuffle mode (restores original order when turned off)
  void toggleShuffle() {
    if (queue.isEmpty) return;

    if (isShuffled.value) {
      // Restore original order
      final currentId = currentSong?.id;
      queue.assignAll(_originalOrder);
      if (currentId != null) {
        currentIndex.value = queue.indexWhere((s) => s.id == currentId);
      } else {
        currentIndex.value = _originalIndex.clamp(0, queue.length - 1);
      }
    } else {
      // Store original order before first shuffle
      if (_originalOrder.isEmpty) {
        _originalOrder = List.from(queue);
        _originalIndex = currentIndex.value;
      }

      final current = currentSong;
      final remainingSongs = List<SongModel>.from(queue)
        ..removeAt(currentIndex.value);

      remainingSongs.shuffle();

      // New behavior: current song moves to position 0
      queue.assignAll([
        current!, // Now at index 0
        ...remainingSongs, // Shuffled rest
      ]);

      currentIndex.value = 0; // Update index to new position
    }

    isShuffled.toggle();
  }

  /// Toggles between loop modes: off → one → all
  void toggleRepeatMode() {
    final modes = RepeatMode.values;
    final next = (repeatMode.value.index + 1) % modes.length;
    repeatMode.value = modes[next];
  }

  /// Gets next song based on current loop mode
  SongModel? get nextSong {
    if (queue.isEmpty) return null;

    switch (repeatMode.value) {
      case RepeatMode.one:
        return currentSong;
      case RepeatMode.all:
        return queue[(currentIndex.value + 1) % queue.length];
      case RepeatMode.off:
        return currentIndex.value < queue.length - 1
            ? queue[currentIndex.value + 1]
            : null;
    }
  }

  Future<void> handleSongCompletion() async {
    final audio = AudioController.instance;

    switch (repeatMode.value) {
      case RepeatMode.one:
        // Restart current song immediately
        await audio.audioPlayer.seek(Duration.zero);
        await audio.audioPlayer.play();
        await predefinedPlaylistsController.incrementPlayCount(currentSong);
        if (Get.isRegistered<PlaylistController>()) {
          final playlistController = PlaylistController.instance;
          if (playlistController.selectedPlaylist.value?.id == "predef_most_played") {
            playlistController.playlistSongs.refresh();
          }
        }
        break;

      case RepeatMode.all:
        // Move to next song (with wrap-around)
        currentIndex.value = (currentIndex.value + 1) % queue.length;
        songController.selectedSong.value = currentSong;

         if (Get.isRegistered<PlaylistController>()) {
          final playlistController = PlaylistController.instance;
          if (playlistController.selectedPlaylist.value?.id == "predef_most_played") {
            playlistController.playlistSongs.refresh();
          }
        }

        // for most and recently played
        await Future.wait([
          predefinedPlaylistsController.addToRecentlyPlayed(currentSong!.id),
          predefinedPlaylistsController.incrementPlayCount(currentSong),
        ]);

         if (Get.isRegistered<PlaylistController>()) {
          final playlistController = PlaylistController.instance;
          if (playlistController.selectedPlaylist.value?.id == "predef_most_played") {
            playlistController.playlistSongs.refresh();
          }
        }

        break;

      case RepeatMode.off:
        if (currentIndex.value < queue.length - 1) {
          // Move to next song
          currentIndex.value++;
          songController.selectedSong.value = currentSong;

          // for most and recently played
          await Future.wait([
            predefinedPlaylistsController.addToRecentlyPlayed(currentSong!.id),
            predefinedPlaylistsController.incrementPlayCount(currentSong),
          ]);
        } else {
          // Stop at queue end
          await audio.audioPlayer.stop();
          audio.isPlaying.value = false;
        }
        break;
    }
  }

  /// Gets previous song
  SongModel? get previousSong {
    if (queue.isEmpty || currentIndex.value <= 0) return null;
    return queue[currentIndex.value - 1];
  }

  // Replace JUST these two methods:
  SongModel? moveNext() {
    if (queue.isEmpty) return null;

    // Always move to next index, regardless of repeat mode
    if (currentIndex.value < queue.length - 1) {
      currentIndex.value++;

      // for most and recently played
      predefinedPlaylistsController.incrementPlayCount(currentSong);
      predefinedPlaylistsController.addToRecentlyPlayed(currentSong!.id);
    } else {
      // At end of queue - behavior depends on repeat mode
      if (repeatMode.value == RepeatMode.all) {
        currentIndex.value = 0; // Wrap around

        // for most and recently played
        predefinedPlaylistsController.incrementPlayCount(currentSong);
        predefinedPlaylistsController.addToRecentlyPlayed(currentSong!.id);
      }
    }

    songController.selectedSong.value = currentSong;
    return currentSong;
  }

  SongModel? movePrevious() {
    if (queue.isEmpty) return null;

    // Always move to previous index if possible
    if (currentIndex.value > 0) {
      currentIndex.value--;
      predefinedPlaylistsController.addToRecentlyPlayed(currentSong!.id);
    } else {
      // At start of queue - behavior depends on repeat mode
      if (repeatMode.value == RepeatMode.all) {
        currentIndex.value = queue.length - 1; // Wrap around
        predefinedPlaylistsController.addToRecentlyPlayed(currentSong!.id);
      }
    }

    songController.selectedSong.value = currentSong;
    return currentSong;
  }

  /// Jumps to specific index in queue
  void jumpToIndex(int index) async {
    if (index >= 0 && index < queue.length) {
      currentIndex.value = index;
      if (songController.selectedSong.value != currentSong) {
        await Future.wait([
          predefinedPlaylistsController.addToRecentlyPlayed(currentSong!.id),
          predefinedPlaylistsController.incrementPlayCount(currentSong),
        ]);
      }
      songController.selectedSong.value = currentSong; // Sync audio
    }
  }

  void jumpToSong(String songId) {
    final index = queue.indexWhere((s) => s.id == songId);
    if (index != -1) jumpToIndex(index); // Reuse the unified logic
  }

  /// Adds songs to end of both queues (shuffled or not)
  void addToQueue(List<SongModel> songs) {
    // Add to both queues
    queue.addAll(songs);
    _originalOrder.addAll(songs);

    // Note: In shuffled state, new songs remain at end
    // User must explicitly shuffle again to mix them
  }

  /// Removes song by ID from both queues
  void removeFromQueue(String songId) {
    // Remove from current queue
    final currentIndexToRemove = queue.indexWhere((s) => s.id == songId);
    if (currentIndexToRemove != -1) {
      // Adjust play position if needed
      if (currentIndexToRemove <= currentIndex.value) {
        currentIndex.value--;
      }
      queue.removeAt(currentIndexToRemove);
    }

    // Remove from original queue
    final originalIndexToRemove = _originalOrder.indexWhere(
      (s) => s.id == songId,
    );
    if (originalIndexToRemove != -1) {
      if (originalIndexToRemove <= _originalIndex) {
        _originalIndex--;
      }
      _originalOrder.removeAt(originalIndexToRemove);
    }
  }
}
