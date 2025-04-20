import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:musiccu/features/musiccu/models/song_model.dart';

class SongRepository extends GetxController {
  static SongRepository get instance => Get.find();
  static const String _songsBoxName = 'songsBox';

  // Store the box reference to avoid opening it multiple times
  Box<SongModel>? _songsBox;

  // Ensure the box is opened only once
  Future<Box<SongModel>> _getSongsBox() async {
    if (_songsBox == null) {
      _songsBox = await Hive.openBox<SongModel>(_songsBoxName);
    }
    return _songsBox!;
  }

  // Clears all songs from Hive
  Future<void> clearAllSongsFromHive() async {
    try {
      final box = await _getSongsBox();
      await box.clear(); // Clears all entries in the box
      print('🧹 All songs have been cleared from Hive.');
    } catch (e) {
      print('🔥 Error clearing songs from Hive: ${e.toString()}');
    }
  }

  // Pick songs and save them to Hive (without duplicates)
  Future<void> pickAndSaveSongs() async {
    try {
      // Step 1: Picking files
      final result = await _pickAudioFiles();
      if (result == null) throw 'User cancelled file selection';
      if (result.files.isEmpty) throw 'No audio files selected';

      // Step 2: Processing files
      final songs = await _processAudioFiles(result.files);

      // Step 3: Saving to Hive
      await _saveSongsToHive(songs);
    } catch (e) {
      throw 'Failed to pick and save songs: ${e.toString()}';
    }
  }

  Future<void> _saveSongsToHive(List<SongModel> newSongs) async {
    try {
      final box = await _getSongsBox();

      // Fetch existing songs' audio URLs in the box
      final existingSongs = box.values.toList();

      // Check for duplicates based on audioUrl (or another unique identifier like songName)
      final uniqueSongs =
          newSongs.where((newSong) {
            // Look for a match based on audioUrl or songName
            return !existingSongs.any(
              (existingSong) =>
                  existingSong.songName == newSong.songName &&
                  existingSong.artistName == newSong.artistName,
            );
          }).toList();

      // Save only unique songs
      if (uniqueSongs.isNotEmpty) {
        await box.addAll(uniqueSongs);
      }
    } catch (e) {
      print('🔥 ERROR inside _saveSongsToHive: $e');
    }
  }

  // Public: fetch saved songs from Hive
  Future<List<SongModel>> getSongsFromHive() async {
    try {
      final box = await _getSongsBox();
      return box.values.toList();
    } catch (e) {
      print('Error fetching songs: ${e.toString()}');
      throw 'Failed to load songs from Hive';
    }
  }

  // Private: open file picker
  Future<FilePickerResult?> _pickAudioFiles() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
      withData: false,
      withReadStream: false,
      lockParentWindow: true,
    );
  }

  // Private: convert picked files into SongModel
  Future<List<SongModel>> _processAudioFiles(List<PlatformFile> files) async {
    final validFiles = files.where((f) => f.path != null);
    return await Future.wait(validFiles.map(_convertToSongModel).toList());
  }

  // Convert file to SongModel
  Future<SongModel> _convertToSongModel(PlatformFile file) async {
    final metadata = await MetadataRetriever.fromFile(File(file.path!));
    return SongModel.fromFile(File(file.path!), metadata);
  }
}
