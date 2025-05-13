import 'dart:io';
import 'dart:typed_data';

import 'package:dart_tags/dart_tags.dart';
import 'package:hive/hive.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path_provider/path_provider.dart';

part 'song_model.g.dart';

@HiveType(typeId: 0)
class SongModel {
  @HiveField(0) final String id; // Now using audioUrl as ID
  @HiveField(1) String imagePath;
  @HiveField(2) String songName;
  @HiveField(3) String artistName;
  @HiveField(4) String albumName;
  @HiveField(5) final String audioUrl;
  @HiveField(6) final int duration;
  @HiveField(7) String genre;
  @HiveField(8) String lyrics;
  @HiveField(9) int playCount;
  @HiveField(10) final int fileSize;
  @HiveField(11) final DateTime createdAt;
  @HiveField(12) DateTime updatedAt;

  SongModel({
    required this.id,
    required this.imagePath,
    required this.songName,
    required this.artistName,
    required this.albumName,
    required this.audioUrl,
    required this.duration,
    required this.genre,
    required this.lyrics,
    required this.playCount,
    required this.fileSize,
    required this.createdAt,
    required this.updatedAt,
  });

  SongModel copyWith({
    String? id,
    String? imagePath,
    String? songName,
    String? artistName,
    String? albumName,
    String? audioUrl,
    int? duration,
    String? genre,
    String? lyrics,
    int? playCount,
    int? fileSize,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SongModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      songName: songName ?? this.songName,
      artistName: artistName ?? this.artistName,
      albumName: albumName ?? this.albumName,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      genre: genre ?? this.genre,
      lyrics: lyrics ?? this.lyrics,
      playCount: playCount ?? this.playCount,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'songName': songName,
      'artistName': artistName,
      'albumName': albumName,
      'audioUrl': audioUrl,
      'duration': duration,
      'genre': genre,
      'lyrics': lyrics,
      'playCount': playCount,
      'fileSize': fileSize,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'] ?? '',
      imagePath: json['imagePath'] ?? '',
      songName: json['songName'] ?? '',
      artistName: json['artistName'] ?? '',
      albumName: json['albumName'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      duration: json['duration'] ?? 0,
      genre: json['genre'] ?? '',
      lyrics: json['lyrics'] ?? '',
      playCount: json['playCount'] ?? 0,
      fileSize: json['fileSize'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  static SongModel empty() => SongModel(
    id: '',
    imagePath: '',
    songName: '',
    artistName: '',
    albumName: '',
    audioUrl: '',
    duration: 0,
    genre: '',
    lyrics: '',
    playCount: 0,
    fileSize: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  static Future<String> extractLyricsWithDartTags(File file) async {
    try {
      final tagProcessor = TagProcessor();
      final List<int> bytes = await file.readAsBytes();
      final tags = await tagProcessor.getTagsFromByteArray(Future.value(bytes)); 

      for (var tag in tags) {
        final tagMap = tag.tags;
        for (var entry in tagMap.entries) {
          final key = entry.key.toLowerCase();
          final value = entry.value.toString();
          if (key.contains('lyrics') || key.contains('unsynchronized lyrics') || key.contains('uslt')) {
            return value;
          }
        }
      }
      return 'No lyrics available';
    } catch (e) {
      return 'Could not load lyrics';
    }
  }

  static Future<String> saveAlbumArt(Uint8List albumArt, String baseName) async {
    final directory = await getApplicationDocumentsDirectory();
    final albumArtFile = File('${directory.path}/album_art_$baseName.jpg');
    await albumArtFile.writeAsBytes(albumArt);
    return albumArtFile.path;
  }

  static Future<SongModel> fromFile(File file, Metadata metadata) async {
    final filePath = file.path;
    final fileName = filePath.split('/').last;
    final baseName = fileName.split('.').first;

    String imagePath = '';
    if (metadata.albumArt != null && metadata.albumArt is Uint8List) {
      imagePath = await SongModel.saveAlbumArt(metadata.albumArt as Uint8List, baseName);
    }

    String lyrics = await extractLyricsWithDartTags(file);

    return SongModel(
      id: filePath, // Using audioUrl as ID
      imagePath: imagePath,
      songName: metadata.trackName ?? baseName,
      artistName: metadata.trackArtistNames?.join(', ') ?? 'Unknown Artist',
      albumName: metadata.albumName ?? 'Unknown Album',
      audioUrl: filePath,
      duration: metadata.trackDuration ?? 0,
      genre: metadata.genre ?? '',
      lyrics: "",
      playCount: 0,
      fileSize: file.lengthSync(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}