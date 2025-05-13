import 'package:get/get.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/now_playing.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/now_playing_yes_lyrics.dart';
import 'package:musiccu/features/musiccu/screens/playlists/inside_playlist/inside_playlist.dart';
import 'package:musiccu/features/musiccu/screens/playlists/playlists_screen.dart';
import 'package:musiccu/features/musiccu/screens/songs/songs.dart';
import 'package:musiccu/features/personlization/screens/settings_screen.dart';
import 'package:musiccu/routes/routes.dart';


class AppRoutes {
  static final pages = [
    GetPage(
      name: ARoutes.songs,
      page: () => const SongsScreen(),
    ),
    GetPage(
      name: ARoutes.settings,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: ARoutes.playlists,
      page: () => const PlaylistsScreen(),
    ),
    GetPage(
      name: ARoutes.insidePlaylist,
      page: () {
        final playlist = Get.arguments['playlist'];  // example of how you pass and access arguments
        return InsidePlaylist(playlist: playlist,);
      },
    ),
    // GetPage(
    //   name: ARoutes.nowPlayingNoLyrics,
    //   page: () {
    //     final bool showIcon = Get.arguments['showIcon']; 
    //     return NowPlayingNoLyrics( showIcon: showIcon,);
    //   },
    // ),
    GetPage(
      name: ARoutes.nowPlayingYesLyrics,
      page: () {
        final bool showIcon = Get.arguments['showIcon']; 
        return NowPlayingYesLyrics(showIcon: showIcon);
      },
    ),
    // Add more GetPage entries if necessary
  ];
}
