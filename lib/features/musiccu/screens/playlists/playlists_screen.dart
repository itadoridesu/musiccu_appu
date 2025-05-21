import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/common/widgets/now_playing_mini_bar.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/playlists_controller.dart';
import 'package:musiccu/features/musiccu/screens/playlists/widgets/add_new.dart';
import 'package:musiccu/features/musiccu/screens/playlists/widgets/playlist_tile.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistController =
        Get.isRegistered<PlaylistController>()
            ? PlaylistController.instance
            : Get.put(PlaylistController());

    playlistController.selectedPlaylist.value = null;
    playlistController.playlistSongs.value = null;

    return Scaffold(
      appBar: AAppBar(
        icon1: Icons.chevron_left,
        icon2: Icons.search,
        title: "Playlists",
        onTapA: () {},
        onTapL: () => Get.back(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            AddNew(),

            const SizedBox(height: 10),

            // Favorited songs playlist tile
            Obx(() {
              return PlayListTile(
              playlist: PredefinedPlaylistsController.instance.favorites.value,
              onLongPress: () {},
              icon: Icon(
                CupertinoIcons.heart_fill,
                size: 20,
                color: Colors.redAccent,
              ),
              );
            }),

            // User-created playlists
            Obx(
              () => Column(
              children: playlistController.playlists.map((playlist) {
                return PlayListTile(playlist: playlist);
              }).toList(),
              ),
            ),

            const Divider(
              height: 15,
              thickness: 0.5,
              color: Colors.grey,
              endIndent: 25,
              indent: 25,
            ),

            const SizedBox(height: 9),

            // Most Played playlist tile (unfilled icon, adjusted color)
            Obx(() {
              return PlayListTile(
              playlist: PredefinedPlaylistsController.instance.mostPlayed.value,
              onLongPress: () {},
              icon: Icon(
                CupertinoIcons.flame, // unfilled flame icon
                size: 20,
              ),
              );
            }),

            // Recently Played playlist tile (unfilled icon, adjusted color)
            Obx(() {
              return PlayListTile(
              playlist: PredefinedPlaylistsController.instance.recentlyPlayed.value,
              onLongPress: () {},
              icon: Icon(
                CupertinoIcons.time, // unfilled clock icon
                size: 20,
              ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: NowPlayingMiniBar(),
    );
  }
}
