import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';

class SongRepository extends GetxController {
  static SongRepository get instance => Get.find();
  static const String _songsBoxName = 'songsBox';

  // Clears all songs from Hive
  // Future<void> clearAllSongsFromHive() async {
  //   try {
  //     final box = Hive.box<SongModel>(_songsBoxName);
  //     await box.clear();
  //   } catch (e) {
  //     throw 'Something went wrong while clearing your songs. Please try again.';
  //   }
  // }

  // Pick songs and save them to Hive (without duplicates)
  Future<void> pickAndSaveSongs() async {
    try {
      // Step 1: Picking files
      final result = await _pickAudioFiles();
      if (result == null) throw 'You cancelled the file selection.';
      if (result.files.isEmpty) throw 'No audio files were selected. Please choose at least one file.';

      // Step 2: Processing files
      final songs = await _processAudioFiles(result.files);

      // Step 3: Saving to Hive
      await _saveSongsToHive(songs);
    } catch (e) {
      throw 'There was an error. Please try again.';
    }
  }

  Future<void> _saveSongsToHive(List<SongModel> newSongs) async {
    try {
      final box = Hive.box<SongModel>(_songsBoxName);

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

      if (uniqueSongs.isNotEmpty) {
        await box.addAll(uniqueSongs);
      }
    } catch (e) {
      throw 'There was an error while saving your songs. Please try again.';
    }
  }

  // Public: fetch saved songs from Hive
  Future<List<SongModel>> getSongsFromHive() async {
    try {
      final box = Hive.box<SongModel>(_songsBoxName);
      return box.values.toList();
    } catch (e) {
      throw 'Failed to load songs. Please check your storage and try again.';
    }
  }

  /// Update single song fields
  Future<void> updateSong(SongModel song) async {
    try {
      final box = Hive.box<SongModel>(_songsBoxName);
      final key = box.keys.firstWhere(
        (k) => box.get(k)?.id == song.id,
        orElse: () => null,
      );

      if (key != null) {
        await box.put(key, song);
      } else {
        throw 'Song not found.';
      }
    } catch (e) {
      throw 'Failed to update the song. Please try again.';
    }
  }

  /// Delete song
  Future<void> deleteSong(String id) async {
    try {
      final box = Hive.box<SongModel>(_songsBoxName);
      final key = box.keys.firstWhere(
        (k) => box.get(k)?.id == id,
        orElse: () => null,
      );

      if (key != null) {
        await box.delete(key);
      } else {
        throw 'Song not found.';
      }
    } catch (e) {
      throw 'Failed to delete the song. Please try again.';
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
