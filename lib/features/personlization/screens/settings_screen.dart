import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/common/widgets/tiles/settings_tile.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/screens/playlists/playlists_screen.dart';
import 'package:musiccu/features/personlization/controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {


    final controller = SongController.instance;

    final themeController = ThemeController.instance;

    

    return Scaffold(
      appBar: AAppBar(
        title: 'Settings',
        icon1: Icons.chevron_left,
        onTapL: () => Get.back(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            SettingsTile(
              icon: CupertinoIcons.music_note,
              text: 'Import Songs',
              onPressed: () => controller.importSongsFromFile(),           
              ),  
            SettingsTile(
              icon: Icons.brightness_6,
              text: 'Dark Mode',
              trailingIcon: Obx(
                () => Switch(
                  value: themeController.isDarkMode.value,
                  onChanged: (value) => themeController.toggleTheme(),
                ),
              ),
            ), 
            SettingsTile(
              icon: Icons.playlist_add,
              text: 'Add Playlist',
              onPressed: () => Get.to(() => PlaylistsScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

