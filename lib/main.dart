import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musiccu/appu.dart';
import 'package:musiccu/features/musiccu/models/song_model.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(SongModelAdapter());


  // Open all boxes upfront
  await Future.wait([
    Hive.openBox<SongModel>('songsBox'),
    Hive.openBox('theme_preferences'), 
  ]);

  
  runApp(const MyApp());
}

