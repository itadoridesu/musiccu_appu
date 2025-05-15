import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/container/deleteBottomBar.dart';
import 'package:musiccu/common/widgets/icons/container_icon.dart';
import 'package:musiccu/common/widgets/icons/pause_stop.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/common/widgets/select/select_screen.dart';
import 'package:musiccu/common/widgets/select/selection_bar.dart';
import 'package:musiccu/common/widgets/select/selection_operations_ui.dart';
import 'package:musiccu/features/musiccu/controllers/selection_controller.dart';
import 'package:musiccu/common/widgets/texts/song_artist.dart';
import 'package:musiccu/common/widgets/tiles/songtile_simple.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/predifined_playlists.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/now_playing.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.song, // Accepting SongModel as a parameter
    this.showIcon = true,
    this.isPauseStop = false,
    this.icon1 = const Icon(CupertinoIcons.heart),
    this.icon2 = const Icon(Icons.more_horiz),
    this.pauseIcon = const Icon(Icons.pause),
    this.stopIcon = const Icon(Icons.stop),
    this.padding = 8,
    this.onTap,
    this.index = 0,
  });

  final SongModel song; // Using SongModel here
  final bool showIcon;
  final bool isPauseStop;
  final Icon icon1;
  final Icon icon2;
  final Icon pauseIcon;
  final Icon stopIcon;
  final double padding;
  final VoidCallback? onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final favoriteController = PredefinedPlaylistsController.instance;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias, // required for ripple to clip to radius
        child: InkWell(
          onLongPress: () {
            // Ensure the controller is created first
            if (!Get.isRegistered<SelectionController<SongModel>>()) {
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
                items: SongController.instance.songs,
                getId: (song) => song.id,
                buildTile: (song) => SongtileSimple(song: song),
                selectionController: selectionController,
                actions: [
                  SelectionAction(
                    icon: Icons.playlist_add,
                    label: 'Add to playlist',
                    onPressed:
                        () => SelectionUI.showBulkAddToPlaylistSheet(
                          context,
                        ), // Empty handler
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
                    onPressed:
                        () { selectionController.showReplacementView(
                          DeleteBottomBar(
                            context: context,
                            onTap: () {
                              // When delete is tapped:
                              SelectionUI.showCompleteDeletionDialog(
                                context,
                              ); // Then show dialog
                            },
                          ),
                        );
                    }
                  ),
                ],
              ),
            );
          },
          onTap:
              onTap ??
              () => Get.to(
                () => NowPlayingNoLyrics(showIcon: showIcon),
                duration: Duration(milliseconds: 600),
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // The image is always displayed
                  Hero(
                    tag: 'image_${song.id}_${showIcon ? 'show' : 'hide'}',
                    child: RoundedImage(
                      imageUrl: song.imagePath,
                      height: 85,
                      width: 85,
                      applyImageRadius: true,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Song and Artist Texts
                  SongArtistText(
                    song: song,
                    showIcon: showIcon,
                    isEllipsis: true,
                  ),
                ],
              ),

              Row(
                children: [
                  // Icon 1 (Heart Icon) if showIcon is true
                  if (showIcon)
                    Obx(() {
                      return ContainerIcon(
                        icon1:
                            favoriteController.isFavoriteRx(song.id).value
                                ? const Icon(
                                  CupertinoIcons.heart_fill,
                                  color: Colors.red,
                                )
                                : const Icon(CupertinoIcons.heart),
                        height: 50,
                        width: 50,
                        onTap: () => favoriteController.toggleFavorite(song.id),
                        color: Colors.transparent,
                      );
                    }),

                  // Icon 2 (Three Dots Icon) if showIcon is true
                  if (showIcon)
                    GestureDetector(
                      onTap:
                          () => SongController.instance.showSongMenu(
                            song,
                            context,
                            index,
                          ),
                      child: icon2,
                    ),

                  // Pause icon with white container and black icon in dark mode, vice versa in light mode
                  if (isPauseStop) Hero(tag: "pause", child: PaustStopButton()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
