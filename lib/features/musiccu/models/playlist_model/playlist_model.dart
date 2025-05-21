import 'package:hive/hive.dart';

part 'playlist_model.g.dart';

@HiveType(typeId: 1)
class PlaylistModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> songIds;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  String? coverImagePath;

  @HiveField(6)  // New field
  bool isCoverManuallySet;

  PlaylistModel({
    required this.id,
    required this.name,
    List<String>? songIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.coverImagePath,
    this.isCoverManuallySet = false,  
  }) : songIds = songIds ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  PlaylistModel copyWith({
    String? id,
    String? name,
    List<String>? songIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? coverImagePath,
    bool? isCoverManuallySet,  // Added parameter
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      songIds: songIds ?? this.songIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      isCoverManuallySet: isCoverManuallySet ?? this.isCoverManuallySet,  // Added
    );
  }

  static Future<PlaylistModel> createNewPlaylist(String name) async {
    final id = await _getNextId();
    return PlaylistModel(id: id.toString(), name: name, songIds: []);
  }

  static Future<int> _getNextId() async {
    var box = await Hive.openBox<int>('playlistIdCounterBox');
    int nextId = box.get('currentId', defaultValue: 0)!;
    await box.put('currentId', nextId + 1);
    return nextId;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'songIds': songIds,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'coverImagePath': coverImagePath,
    'isCoverManuallySet': isCoverManuallySet,  // Added
  };

  factory PlaylistModel.fromJson(Map<String, dynamic> json) => PlaylistModel(
    id: json['id'],
    name: json['name'],
    songIds: List<String>.from(json['songIds'] ?? []),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    coverImagePath: json['coverImagePath'],
    isCoverManuallySet: json['isCoverManuallySet'] ?? false,  // Added
  );

  static PlaylistModel empty() => PlaylistModel(
    id: '', 
    name: 'Untitled Playlist',
    isCoverManuallySet: false,  // Added
  );
}