import 'dart:io';
import 'dart:typed_data';

import 'package:dart_tags/dart_tags.dart';
import 'package:hive/hive.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path_provider/path_provider.dart';

part 'song_model.g.dart';

@HiveType(typeId: 0) // Assign a unique ID to this model type
class SongModel {
  @HiveField(0) final String id;
  @HiveField(1) String imagePath;
  @HiveField(2) String songName;
  @HiveField(3) String artistName;
  @HiveField(4) String albumName;
  @HiveField(5) final String audioUrl;
  @HiveField(6) final int duration; // Duration in seconds
  @HiveField(7) String genre;
  @HiveField(8) String lyrics;
  @HiveField(9) int playCount;
  @HiveField(10) bool isFavorite;
  @HiveField(11) final int fileSize; // in bytes
  @HiveField(12) final DateTime createdAt;
  @HiveField(13) DateTime updatedAt;

  // Constructor
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
    required this.isFavorite,
    required this.fileSize,
    required this.createdAt,
    required this.updatedAt,
  });




  // Convert SongModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'songName': songName,
      'artistName': artistName,
      'albumName': albumName,
      'audioUrl': audioUrl,
      'duration': duration, // Store as seconds
      'genre': genre,
      'lyrics': lyrics,
      'playCount': playCount,
      'isFavorite': isFavorite,
      'fileSize': fileSize,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create SongModel from JSON
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
      isFavorite: json['isFavorite'] ?? false,
      fileSize: json['fileSize'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Empty Helper Function
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
    isFavorite: false,
    fileSize: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );



  
  static Future<int> getId() async {
    var box = await Hive.openBox<int>('idCounterBox');
    int nextId = box.get('currentId', defaultValue: 0)!;
    await box.put('currentId', nextId + 1);
    return nextId;
  }

     // 2. Extract lyrics using dart_tags (for MP3/ID3)

static Future<String> extractLyricsWithDartTags(File file) async {
  try {
    final tagProcessor = TagProcessor();
    final List<int> bytes = await file.readAsBytes(); // explicitly List<int>

    final tags = await tagProcessor.getTagsFromByteArray(Future.value(bytes)); 

    for (var tag in tags) {
      final tagMap = tag.tags;

      for (var entry in tagMap.entries) {
        final key = entry.key.toLowerCase();
        final value = entry.value.toString();

        if (key.contains('lyrics') || key.contains('unsynchronized lyrics') || key.contains('uslt')) {
          print('🎵 Found lyrics: $value');
          return value;
        }
      }
    }

    return 'No lyrics available';
  } catch (e) {
    print('❌ Error while extracting lyrics: $e');
    return 'Could not load lyrics';
  }
}

  // Save album art image to file system
  static Future<String> saveAlbumArt(Uint8List albumArt, String baseName) async {
    final directory = await getApplicationDocumentsDirectory();
    final albumArtFile = File('${directory.path}/album_art_$baseName.jpg');
    await albumArtFile.writeAsBytes(albumArt);
    return albumArtFile.path;
  }

  // Create SongModel from file and metadata
  static Future<SongModel> fromFile(File file, Metadata metadata) async {
    final filePath = file.path;
    final fileName = filePath.split('/').last;
    final baseName = fileName.split('.').first;

    // We just get the image path here, without any fallback logic
    String imagePath = '';

    if (metadata.albumArt != null && metadata.albumArt is Uint8List) {
      // Save the album art and use the returned path
      imagePath = await SongModel.saveAlbumArt(metadata.albumArt as Uint8List, baseName);
    }




    String lyrics = await extractLyricsWithDartTags(file);

    final id = await getId();

    return SongModel(
      id: id.toString(), // Generate a unique ID
      imagePath: imagePath, // Only the actual file path or empty string
      songName: metadata.trackName ?? baseName,
      artistName: metadata.trackArtistNames?.join(', ') ?? 'Unknown Artist',
      albumName: metadata.albumName ?? 'Unknown Album',
      audioUrl: filePath,
      duration: metadata.trackDuration ?? 0, // Store as seconds
      genre: metadata.genre ?? '',
      lyrics: "I am so tired bro offffff hhhhh", 
      playCount: 0,
      isFavorite: false,
      fileSize: file.lengthSync(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Default Dummy Helper Function
}
