import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musiccu/appu.dart';
import 'package:musiccu/data/services/navigation_safetly_services.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';

 void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(SongModelAdapter());
  Hive.registerAdapter(PlaylistModelAdapter());

  Get.put<NavigationController>(NavigationController());

  // Open all boxes upfront
  await Future.wait([
    Hive.openBox('theme_preferences'), 
    Hive.openBox<SongModel>('songsBox'),
    Hive.openBox<PlaylistModel>('playlists'),
  ]);

  
  runApp(const MyApp());
}

