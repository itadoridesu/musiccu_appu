import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/common/widgets/container/bottomBarButton.dart';
import 'package:musiccu/common/widgets/now_playing_mini_bar.dart';
import 'package:musiccu/common/widgets/select/select_screen.dart';
import 'package:musiccu/common/widgets/select/selection_bar.dart';
import 'package:musiccu/common/widgets/select/selection_operations_ui.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/selection_controller.dart';
import 'package:musiccu/common/widgets/tiles/songtile_simple.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/playlists_controller.dart';
import 'package:musiccu/features/musiccu/controllers/que_controller.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/musiccu/screens/playlists/inside_playlist/widgets/play_shuffle.dart';
import 'package:musiccu/features/musiccu/screens/playlists/inside_playlist/widgets/playlist_attributes.dart';

class InsidePlaylist extends StatelessWidget {
  const InsidePlaylist({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PlaylistController.instance;

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
        child: Column(
          children: [
            const SizedBox(height: 10),
            Obx(() {
              final songs = controller.playlistSongs.value;

              return Column(
                children: [
                   PlaylistAttributes(),
            const SizedBox(height: 15),
                  if (songs != null && songs.isNotEmpty) PlayShuffle(),
                  const SizedBox(height: 7),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: songs!.length,
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
                            if (controller.selectedPlaylist.value!.id !=
                                    "predef_recently_played" &&
                                controller.selectedPlaylist.value!.id !=
                                    "predef_most_played") {
                              if (!Get.isRegistered<
                                SelectionController<SongModel>
                              >()) {
                                Get.put(SelectionController<SongModel>());
                              }
                              final selectionController =
                                  Get.find<SelectionController<SongModel>>();

                              selectionController.clearSelection();
                              selectionController.restoreDefaultView();
                              selectionController.toggleSelection(song.id);

                              Get.to(
                                () => SelectionScreen<SongModel>(
                                  items: songs,
                                  getId: (song) => song.id,
                                  buildTile:
                                      (song) => SongtileSimple(
                                        song: song,
                                        heigt: 75,
                                        width: 75,
                                        heightBtwText: 2,
                                        artistNameStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(fontSize: 15),
                                        songNameStyle: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(fontSize: 20),
                                      ),
                                  selectionController: selectionController,
                                  actions: [
                                    SelectionAction(
                                      icon: Icons.playlist_add,
                                      label: 'Add to playlist',
                                      onPressed: () {
                                        SelectionUI.showBulkAddToPlaylistSheet(
                                          context,
                                        );
                                      }, // Empty handler
                                    ),
                                    SelectionAction(
                                      icon: Icons.queue_music,
                                      label: 'Up next',
                                      onPressed: () {}, // Empty handler
                                    ),
                                    SelectionAction(
                                      icon: Icons.share,
                                      label: 'Share',
                                      onPressed: () {}, // Empty handler
                                    ),
                                    SelectionAction(
                                      icon: Icons.delete,
                                      label: 'Delete',
                                      onPressed: () {
                                        selectionController.showReplacementView(
                                          BottomBarButton(
                                            context: context,
                                            onTap: () {
                                              SelectionUI.showDeleteDialog(
                                                context,
                                                controller
                                                    .selectedPlaylist
                                                    .value!
                                                    .name,
                                              );
                                            },
                                            selectionController:
                                                selectionController,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: SongtileSimple(
                            song: song,
                            heigt: 75,
                            width: 75,
                            heightBtwText: 2,
                            isMostPlayed:
                                controller.selectedPlaylist.value!.id ==
                                "predef_most_played",
                            artistNameStyle: Theme.of(
                              context,
                            ).textTheme.titleLarge!.copyWith(fontSize: 15),
                            songNameStyle: Theme.of(
                              context,
                            ).textTheme.headlineMedium!.copyWith(fontSize: 20),
                            onTap: () {
                              SongController.instance.updateSelectedSong(
                                song,
                                navigate: true,
                                context: context,
                              );

                              QueueController.instance.setQueue(
                                songs,
                                startingIndex: index,
                              );

                              // for recently and most played

                              PredefinedPlaylistsController.instance
                                  .incrementPlayCount(song);

                              PredefinedPlaylistsController.instance
                                  .addToRecentlyPlayed(song.id);

                               
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }),

            const SizedBox(height: 15),
          ],
        ),
      ),
      bottomNavigationBar: NowPlayingMiniBar(),
    );
  }
}
