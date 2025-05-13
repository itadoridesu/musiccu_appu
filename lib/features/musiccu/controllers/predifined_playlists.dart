import 'package:get/get.dart';
import 'package:musiccu/data/repositories/playlists_repository.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/utils/popups/loader.dart';

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
  RxBool isFavoriteRx(String songId) => favorites.value.songIds.contains(songId).obs;

  /// Toggles favorite status if [usualToggle] is true, otherwise only adds if not already favorite.
  Future<void> toggleFavorite(String songId, {bool usualToggle = true}) async {
    final newSongIds = List<String>.from(favorites.value.songIds);

    final isAlreadyFavorite = newSongIds.contains(songId);

    if (usualToggle) {
      // Standard toggle: add if not present, remove if present
      if (isAlreadyFavorite) {
        newSongIds.remove(songId);
      } else {
        newSongIds.add(songId);
      }
    } else {
      // Only add if not already favorite
      if (isAlreadyFavorite) return;
      newSongIds.add(songId);
      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Added to favorites!',
      );
    }

    final updated = favorites.value.copyWith(songIds: newSongIds);
    await _playlistRepo.updatePlaylist(updated);
    favorites.value = updated;
  }



  // Recently Played methods
  Future<void> addToRecentlyPlayed(String songId) async {
    final newSongIds = List<String>.from(recentlyPlayed.value.songIds)
      ..remove(songId)
      ..insert(0, songId);
    
    if (newSongIds.length > 50) {
      newSongIds.removeRange(50, newSongIds.length);
    }
    
    final updated = recentlyPlayed.value.copyWith(songIds: newSongIds);
    await _playlistRepo.updatePlaylist(updated);
    recentlyPlayed.value = updated;
  }
}