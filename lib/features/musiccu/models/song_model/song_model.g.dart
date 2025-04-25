// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongModelAdapter extends TypeAdapter<SongModel> {
  @override
  final int typeId = 0;

  @override
  SongModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongModel(
      id: fields[0] as String,
      imagePath: fields[1] as String,
      songName: fields[2] as String,
      artistName: fields[3] as String,
      albumName: fields[4] as String,
      audioUrl: fields[5] as String,
      duration: fields[6] as int,
      genre: fields[7] as String,
      lyrics: fields[8] as String,
      playCount: fields[9] as int,
      isFavorite: fields[10] as bool,
      fileSize: fields[11] as int,
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SongModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.songName)
      ..writeByte(3)
      ..write(obj.artistName)
      ..writeByte(4)
      ..write(obj.albumName)
      ..writeByte(5)
      ..write(obj.audioUrl)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.genre)
      ..writeByte(8)
      ..write(obj.lyrics)
      ..writeByte(9)
      ..write(obj.playCount)
      ..writeByte(10)
      ..write(obj.isFavorite)
      ..writeByte(11)
      ..write(obj.fileSize)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
