import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/common/widgets/glassmorhphism/glass_effect_container.dart';
import 'package:musiccu/common/widgets/tiles/song_tile.dart';
import 'package:musiccu/features/musiccu/controllers/audio_controller.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/screens/songs/widgets/all_songs_container.dart';
import 'package:musiccu/features/personlization/screens/settings_screen.dart';

class SongsScreen extends StatelessWidget {
  const SongsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(SongController());

    final audioController = Get.put(AudioController());

    print('🔄 BUILDING WIDGET WITH ${controller.songs.length} SONGS');


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
       bottomNavigationBar: Obx(() {
        final selected = controller.selectedSong.value;
        if (selected == null) return SizedBox.shrink();

        // hero tags only fire on showIcon=false
        return GlassEffectContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: SongTile(
              song: selected,
              showIcon: false,            
              isPauseStop: true,
            ),
          ),
        );
      }),
    );
  }
}
