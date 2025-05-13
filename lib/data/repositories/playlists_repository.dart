import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';

class PlaylistRepository extends GetxController {
  static PlaylistRepository get instance => Get.find();
  
  final Box<PlaylistModel> _playlistBox = Hive.box<PlaylistModel>("playlists");


  // --- CRUD Operations ---
  Future<void> addPlaylist(PlaylistModel playlist) async {
    await _playlistBox.put(playlist.id, playlist);
  }

  Future<List<PlaylistModel>> getAllPlaylists() async {
    return _playlistBox.values.toList();
  }

  Future<PlaylistModel?> getPlaylist(String id) async {
    return _playlistBox.get(id);
  }

  Future<void> updatePlaylist(PlaylistModel playlist) async {
    await _playlistBox.put(playlist.id, playlist);
  }

  Future<void> deletePlaylist(String id) async {
    await _playlistBox.delete(id);
  }

  // --- Song Management ---
  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    final playlist = await getPlaylist(playlistId);
    if (playlist != null && !playlist.songIds.contains(songId)) {
      final updatedPlaylist = playlist.copyWith(
        songIds: [...playlist.songIds, songId],
        updatedAt: DateTime.now(),
      );
      await updatePlaylist(updatedPlaylist);
    } else {
      throw "Song already in playlist or playlist not found";
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    final playlist = await getPlaylist(playlistId);
    if (playlist != null) {
      final updatedSongIds = playlist.songIds.where((id) => id != songId).toList();
      final updatedPlaylist = playlist.copyWith(
        songIds: updatedSongIds,
        updatedAt: DateTime.now(),
      );
      await updatePlaylist(updatedPlaylist);
    }
  }

  Future<void> deleteAllPlaylists() async {
    await _playlistBox.clear();
    
    // Also reset the ID counter
    final idBox = await Hive.openBox<int>('playlistIdCounterBox');
    await idBox.put('currentId', 0);
    await idBox.close();
  }


}