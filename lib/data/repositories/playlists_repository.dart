import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';

class PlaylistRepository extends GetxController {
  static PlaylistRepository get instance => Get.find();
  
  static const String _playlistBoxName = 'playlists';
  static const String _idCounterBoxName = 'playlistIdCounter';

  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    // Open boxes if they're not already open
    if (!Hive.isBoxOpen(_playlistBoxName)) {
      await Hive.openBox<PlaylistModel>(_playlistBoxName);
    }
    if (!Hive.isBoxOpen(_idCounterBoxName)) {
      await Hive.openBox<int>(_idCounterBoxName);
    }

    // Initialize counter if needed
    final idBox = Hive.box<int>(_idCounterBoxName);
    if (!idBox.containsKey('currentId')) {
      await idBox.put('currentId', 0);
    }
    
    _isInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initialize();
    }
  }

  // --- ID Management ---
  Future<int> _getNextId() async {
    await _ensureInitialized();
    final box = Hive.box<int>(_idCounterBoxName);
    final currentId = box.get('currentId', defaultValue: 0)!;
    await box.put('currentId', currentId + 1);
    return currentId;
  }

  Future<void> _decrementId() async {
    await _ensureInitialized();
    final box = Hive.box<int>(_idCounterBoxName);
    final currentId = box.get('currentId', defaultValue: 0)!;
    if (currentId > 0) {
      await box.put('currentId', currentId - 1);
    }
  }

  // --- CRUD Operations ---
  Future<void> addPlaylist(PlaylistModel playlist) async {
    await _ensureInitialized();
    final box = Hive.box<PlaylistModel>(_playlistBoxName);
    final id = await _getNextId();
    final newPlaylist = playlist.copyWith(id: id.toString());
    await box.put(id.toString(), newPlaylist);
  }

  Future<List<PlaylistModel>> getAllPlaylists() async {
    await _ensureInitialized();
    final box = Hive.box<PlaylistModel>(_playlistBoxName);
    return box.values.toList();
  }

  Future<PlaylistModel?> getPlaylist(String id) async {
    await _ensureInitialized();
    final box = Hive.box<PlaylistModel>(_playlistBoxName);
    return box.get(id);
  }

  Future<void> updatePlaylist(PlaylistModel playlist) async {
    await _ensureInitialized();
    final box = Hive.box<PlaylistModel>(_playlistBoxName);
    await box.put(playlist.id, playlist);
  }

  Future<void> deletePlaylist(String id) async {
    await _ensureInitialized();
    final box = Hive.box<PlaylistModel>(_playlistBoxName);
    await box.delete(id);
    await _decrementId();
  }

  // --- Song Management ---
  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    await _ensureInitialized();
    final playlist = await getPlaylist(playlistId);
    if (playlist != null && !playlist.songIds.contains(songId)) {
      playlist.songIds.add(songId);
      await updatePlaylist(playlist);
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    await _ensureInitialized();
    final playlist = await getPlaylist(playlistId);
    if (playlist != null) {
      playlist.songIds.remove(songId);
      await updatePlaylist(playlist);
    }
  }

  Future<void> deleteAllPlaylists() async {
  await _ensureInitialized();
  
  // Clear all playlists
  final playlistBox = Hive.box<PlaylistModel>(_playlistBoxName);
  await playlistBox.clear();
  
  // Reset the ID counter
  final idBox = Hive.box<int>(_idCounterBoxName);
  await idBox.put('currentId', 0);

 }

}