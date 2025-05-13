import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/common/widgets/now_playing_mini_bar.dart';
import 'package:musiccu/common/widgets/select/select_screen.dart';
import 'package:musiccu/common/widgets/select/selection_controller.dart';
import 'package:musiccu/common/widgets/tiles/songtile_simple.dart';
import 'package:musiccu/features/musiccu/controllers/playlists_controller.dart';
import 'package:musiccu/features/musiccu/controllers/que_controller.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/musiccu/screens/playlists/inside_playlist/widgets/play_shuffle.dart';
import 'package:musiccu/features/musiccu/screens/playlists/inside_playlist/widgets/playlist_attributes.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class InsidePlaylist extends StatelessWidget {
  const InsidePlaylist({super.key, required this.playlist});

  final PlaylistModel playlist;

  @override
  Widget build(BuildContext context) {
    final controller = PlaylistController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AAppBar(
        title: "",
        icon1: Icons.chevron_left,
        onTapL: () => Get.back(),
        actionsWidget: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => controller.showPlaylistOptions(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => FutureBuilder<List<SongModel>>(
            key: Key(controller.refreshFlag.value.toString()),
            future: controller.fetchSongsOfSelectedPlaylist(),
            builder: (context, snapshot) {
              // Handle loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              // Handle error state
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final songs = snapshot.data!;

              // Initial data loaded, wrap everything in Obx

              return Column(
                children: [
                  const SizedBox(height: 10),
                  PlaylistAttributes(playlist: playlist),
                  const SizedBox(height: 15),
                  PlayShuffle(),
                  const SizedBox(height: 7),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: songs.length,
                    itemBuilder: (_, index) {
                      final song = songs[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 16,
                        ),
                        child: GestureDetector(
                          onLongPress: () {
                            // Ensure the controller is created first
                            if (!Get.isRegistered<
                              SelectionController<SongModel>
                            >()) {
                              Get.put(SelectionController<SongModel>());
                            }
                            final selectionController =
                                Get.find<SelectionController<SongModel>>();

                            selectionController
                                .clearSelection(); // Optional: remove previous selection
                            selectionController.toggleSelection(
                              song.id,
                            ); // Pre-select the long-pressed song

                            Get.to(
                              () => SelectionScreen<SongModel>(
                                items: songs,
                                getId: (song) => song.id,
                                buildTile: (song) => SongtileSimple(song: song),
                                selectionController: selectionController,
                              ),
                            );
                          },
                          child: SongtileSimple(
                            song: song,
                            onTap: () {
                              SongController.instance.updateSelectedSong(
                                song,
                                navigate: true,
                                context: context,
                              );

                              QueueController.instance.setQueue(songs, startingIndex: index);
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: NowPlayingMiniBar(),
    );
  }
}
