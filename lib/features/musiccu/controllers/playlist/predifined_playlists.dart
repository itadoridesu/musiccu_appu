import 'dart:async';

import 'package:get/get.dart';
import 'package:musiccu/data/repositories/playlists_repository.dart';
import 'package:musiccu/data/repositories/songs_repository.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/playlists_controller.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/utils/popups/loader.dart';
import 'package:collection/collection.dart'; // For ListEquality

class PredefinedPlaylistsController extends GetxController {
  static PredefinedPlaylistsController get instance => Get.find();

  final PlaylistRepository _playlistRepo = Get.put(PlaylistRepository());

  // Public reactive playlists (non-nullable)
  final Rx<PlaylistModel> favorites = PlaylistModel.empty().obs;
  final Rx<PlaylistModel> mostPlayed = PlaylistModel.empty().obs;
  final Rx<PlaylistModel> recentlyPlayed = PlaylistModel.empty().obs;

  // Playlist IDs
  static const String favoritesId = 'predef_favorites';
  static const String mostPlayedId = 'predef_most_played';
  static const String recentlyPlayedId = 'predef_recently_played';

  @override
  void onInit() {
    super.onInit();
    _initializePredefinedPlaylists();
  }

  Future<void> _initializePredefinedPlaylists() async {
    await Future.wait([
      _initializePlaylist(
        id: favoritesId,
        name: 'Favorites',
        storageVar: favorites,
      ),
      _initializePlaylist(
        id: mostPlayedId,
        name: 'Most Played',
        storageVar: mostPlayed,
      ),
      _initializePlaylist(
        id: recentlyPlayedId,
        name: 'Recently Played',
        storageVar: recentlyPlayed,
      ),
    ]);
  }

  Future<void> _initializePlaylist({
    required String id,
    required String name,
    required Rx<PlaylistModel> storageVar,
  }) async {
    var playlist = await _playlistRepo.getPlaylist(id);
    if (playlist == null) {
      playlist = PlaylistModel(
        id: id,
        name: name,
        songIds: [],
        coverImagePath: '',
      );
      await _playlistRepo.addPlaylist(playlist);
    }
    storageVar.value = playlist;
  }

  // Favorites-specific methods
  bool isFavorite(String songId) => favorites.value.songIds.contains(songId);
  RxBool isFavoriteRx(String songId) =>
      favorites.value.songIds.contains(songId).obs;

  /// Toggles favorite status if [usualToggle] is true, otherwise only adds if not already favorite.
  Future<void> toggleFavorite(String songId, {bool usualToggle = true}) async {
    final newSongIds = List<String>.from(favorites.value.songIds);
    final isAlreadyFavorite = newSongIds.contains(songId);

    if (usualToggle) {
      // FIRST check if controller exists
      if (Get.isRegistered<PlaylistController>()) {
        final playlistController = PlaylistController.instance;

        // THEN check if viewing favorites
        if (playlistController.selectedPlaylist.value?.id ==
            "predef_favorites") {
          if (isAlreadyFavorite) {
            newSongIds.remove(songId);
            await playlistController.removeSongFromFavorites(songId);
          } else {
            newSongIds.add(songId);
            await playlistController.addSongToFavorites(songId);
          }
        } else {
          if (isAlreadyFavorite) {
            newSongIds.remove(songId);
          } else {
            newSongIds.add(songId);
          }
        }
      } else {
        if (isAlreadyFavorite) {
          newSongIds.remove(songId);
        } else {
          newSongIds.add(songId);
        }
      }
    }
    // For forced additions (like from song menu)
    else if (!isAlreadyFavorite) {
      newSongIds.add(songId);
    }

    // Always update favorites model
    final updatedFavorites = favorites.value.copyWith(songIds: newSongIds);
    await _playlistRepo.updatePlaylist(updatedFavorites);
    favorites.value = updatedFavorites;

    if (!usualToggle && !isAlreadyFavorite) {
      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Added to favorites!',
      );
    }
  }

  Future<void> addMultipleToFavorites(List<String> songIds) async {
    try {
      if (songIds.isEmpty) return;

      final newSongIds = List<String>.from(favorites.value.songIds);
      int addedCount = 0;

      for (final songId in songIds) {
        if (!newSongIds.contains(songId)) {
          newSongIds.add(songId);
          addedCount++;
        }
      }

      if (addedCount == 0) return;

      final updated = favorites.value.copyWith(songIds: newSongIds);
      await _playlistRepo.updatePlaylist(updated);
      favorites.value = updated;

      TLoaders.successSnackBar(
        title: 'Added to Favorites',
        message:
            addedCount == 1
                ? '1 song added to favorites'
                : '$addedCount songs added to favorites',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Failed to add to favorites',
        message: e.toString(),
      );
      rethrow; // Optional: rethrow if you want calling code to handle it too
    }
  }

  Future<void> removeMultipleFromFavorites(List<String> songIds) async {
    try {
      if (songIds.isEmpty) return;

      PlaylistController.instance.removeSelectedSongs(
        songIds,
        fromFavorites: true,
        usualCall: false,
      );

      // 1. Update in repository
      final newSongIds =
          favorites.value.songIds.where((id) => !songIds.contains(id)).toList();
      final updated = favorites.value.copyWith(songIds: newSongIds);

      // 2. Update local state
      favorites.value = updated;

      // 3. Show success feedback
      TLoaders.successSnackBar(
        title: 'Removed',
        message:
            '${songIds.length} ${songIds.length > 1 ? 'songs' : 'song'} removed from favorites',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to remove from favorites',
      );
      rethrow;
    }
  }

  // called when deleting songs from the main list
  Future<void> removeFromPredefinedPlaylists(List<String> songIds) async {
    if (songIds.isEmpty) return;

    // Remove from Favorites
    await _removeFromPlaylist(favorites, songIds);

    // Remove from Most Played
    await _removeFromPlaylist(mostPlayed, songIds);

    // Remove from Recently Played
    await _removeFromPlaylist(recentlyPlayed, songIds);
  }

  Future<void> _removeFromPlaylist(
    Rx<PlaylistModel> playlist,
    List<String> songIds,
  ) async {
    final newSongIds =
        playlist.value.songIds.where((id) => !songIds.contains(id)).toList();
    final updated = playlist.value.copyWith(songIds: newSongIds);
    await _playlistRepo.updatePlaylist(updated);
    playlist.value = updated;
  }

  // Recently Played methods
  Future<void> addToRecentlyPlayed(String songId) async {
    final newSongIds =
        List<String>.from(recentlyPlayed.value.songIds)
          ..remove(songId)
          ..insert(0, songId);

    if (newSongIds.length > 15) {
      newSongIds.removeRange(15, newSongIds.length);
    }

    final updated = recentlyPlayed.value.copyWith(songIds: newSongIds);
    await _playlistRepo.updatePlaylist(updated);
    recentlyPlayed.value = updated;

    if (Get.isRegistered<PlaylistController>()) {
      final playlistController = PlaylistController.instance;

      // THEN check if viewing favorites
      if (playlistController.selectedPlaylist.value?.id == recentlyPlayedId) {
        playlistController.handleRecentlyPlayedUpdate(
          songId,
        ); // Call our dedicated function
      }
    }
  }

  Future<void> incrementPlayCount(SongModel? song) async {
    if (song == null) return;
    try {
      // IMMEDIATE local update first
      final updatedSong = song.copyWith(playCount: song.playCount + 1);

      // Update in controller's memory
      SongController
          .instance
          .songs
          .firstWhere((s) => s.id == song.id)
          .playCount = updatedSong.playCount;

      unawaited(SongRepository.instance.updateSong(updatedSong));

      await refreshMostPlayedPlaylist();

      // Update database (fire and forget)

      // Force refresh both playlists
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Play Count Error', message: e.toString());
    }
  }

  Future<void> refreshMostPlayedPlaylist() async {
    try {
      // Get all songs with at least 1 play
      final songsWithPlays =
          SongController.instance.songs
              .where((song) => song.playCount > 0)
              .toList();

      // Sort primarily by play count, secondarily by current position
      songsWithPlays.sort((a, b) {
        final countCompare = b.playCount.compareTo(a.playCount);
        if (countCompare != 0) return countCompare;

        // For songs with equal play count, check their current position
        final currentIds = mostPlayed.value.songIds;
        final aIndex = currentIds.indexOf(a.id);
        final bIndex = currentIds.indexOf(b.id);

        // Songs not in current list get lower priority
        if (aIndex == -1) return 1;
        if (bIndex == -1) return -1;

        // Higher index means more recently added
        return bIndex.compareTo(aIndex);
      });

      // Take top 20
      final topSongIds = songsWithPlays.take(20).map((s) => s.id).toList();

      // Check if the list has actually changed
      final equality = const ListEquality<String>();
      if (!equality.equals(mostPlayed.value.songIds, topSongIds)) {
        final updatedPlaylist = mostPlayed.value.copyWith(
          songIds: topSongIds,
          coverImagePath:
              songsWithPlays.isNotEmpty ? songsWithPlays.first.imagePath : '',
        );

        await _playlistRepo.updatePlaylist(updatedPlaylist);
        mostPlayed.value = updatedPlaylist;

        // Update UI if viewing this playlist
        if (Get.isRegistered<PlaylistController>()) {
          final pc = PlaylistController.instance;
          if (pc.selectedPlaylist.value?.id == mostPlayedId) {
            pc.handleMostPlayedUpdate(topSongIds);
          }
        }
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to refresh most played: ${e.toString()}',
      );
    }
  }
}
