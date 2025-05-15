import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/common/widgets/now_playing_mini_bar.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/que_controller.dart';
import 'package:musiccu/features/musiccu/controllers/ui_controllers/image_controller.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/screens/songs/widgets/all_songs_container.dart';
import 'package:musiccu/features/personlization/screens/settings_screen.dart';

class SongsScreen extends StatelessWidget {
  const SongsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Get.put(ImageController());

    final controller = SongController.instance;

    Get.put(QueueController());

    Get.put(PredefinedPlaylistsController());

    
    return Scaffold(
      appBar: AAppBar(
        icon1: Icons.chevron_left,
        icon2: CupertinoIcons.gear,
        title: "Songs",
        onTapA: () => Get.to(() => const SettingsScreen()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Obx(() {
          // The 'songs' list is being fetched and updated reactively
          final songs = controller.songs;

          // Check if there are any songs to display
          if (songs.isEmpty) {
            return Center(child: Text("No songs available"));
          }

          return AllSongsContainer(songs: songs);
        }),
      ),
       bottomNavigationBar: NowPlayingMiniBar(),
    );
  }
}

