import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musiccu/appu.dart';
import 'package:musiccu/features/musiccu/models/song_model.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(SongModelAdapter());

  // Open Hive boxes  (add the boxes you need here)
  await Hive.openBox<SongModel>('songsBox'); // Ensure it's typed correctly with SongModel
  
  runApp(const MyApp());
}

