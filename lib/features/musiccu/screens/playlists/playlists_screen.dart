import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/features/musiccu/controllers/playlists_controller.dart';
import 'package:musiccu/features/musiccu/screens/playlists/widgets/add_new.dart';
import 'package:musiccu/features/musiccu/screens/playlists/widgets/playlist_tile.dart';
import 'package:musiccu/utils/constants/colors.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key, this.bottomSheet = false}); 

  final bool bottomSheet;

  @override
  Widget build(BuildContext context) {

    final playlistController = Get.put(PlaylistController());
    //final dark = THelperFunctions.isDarkMode(context);

    

    return Scaffold(
      backgroundColor: !bottomSheet? Theme.of(context).scaffoldBackgroundColor : AColors.dark,
      appBar: bottomSheet
          ? null
          : AAppBar(
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

            Obx(
              () => Column(
                children:
                    playlistController.playlists.map((playlist) {
                      return PlayListTile(playlist: playlist,);
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => playlistController.deleteAllPlaylists()),
    );
  }
}
