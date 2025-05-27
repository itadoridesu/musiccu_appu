import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/common/widgets/icons/container_icon.dart';
import 'package:musiccu/common/widgets/tiles/songtile_simple.dart';
import 'package:musiccu/features/musiccu/controllers/audio/audio_controller.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/screens/now_playing/now_playing.dart';
import 'package:musiccu/features/musiccu/controllers/que_controller.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songController = SongController.instance;
    final audioController = AudioController.instance;
    final queueController = QueueController.instance;
    final isDarkMode = THelperFunctions.isDarkMode(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        Get.off(
          () => NowPlayingNoLyrics(showIcon: false),
          duration: Duration(milliseconds: 600),
        );
      },
      child: Scaffold(
        appBar: AAppBar(
          title: 'Queue',
          actionsWidget: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
          leadingWidget: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              Get.off(
                () => NowPlayingNoLyrics(showIcon: false),
                duration: Duration(milliseconds: 600),
              );
            },
          ),
        ),
        body: Obx(() {
          final queue = queueController.queue;

          if (queue.isEmpty) {
            return const Center(
              child: Text(
                'Queue is empty',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          return Column(
            children: [
              // Sticky header part
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: SongtileSimple(
                        song: songController.selectedSong.value!,
                        heigt: 85,
                        width: 85,
                        radius: 27,
                        heightBtwText: 4,
                        movingText: true,
                        showHero: true,
                        onTap: () {
                          Get.off(
                            () => NowPlayingNoLyrics(showIcon: false),
                            duration: const Duration(milliseconds: 600),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        audioController.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 40,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () => audioController.togglePlayPause(),
                    ),
                  ],
                ),
              ),
              // Scrollable list with reordering
              Expanded(
                child: ReorderableColumn(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  onReorder: (oldIndex, newIndex) {
                    queueController.reorderQueue(oldIndex, newIndex);
                  },
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  buildDraggableFeedback: (context, constraints, child) {
                    return Material(
                      elevation: 7,
                      color: Colors.transparent,
                      child: ConstrainedBox(
                        constraints: constraints,
                        child: child,
                      ),
                    );
                    
                  },
                   // Add these new properties for faster edge scrolling:
    scrollController: ScrollController(),
    scrollAnimationDuration: const Duration(milliseconds: 100), // Faster animation
   
                  children:
                      queue.map((song) {
                        final index = queue.indexOf(song);
                        return Padding(
                          key: ValueKey(song.id),
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Slidable(
                            key: ValueKey('slidable_${song.id}'),
                            endActionPane: ActionPane(
                              extentRatio: 0.2,
                              motion: const BehindMotion(),
                              dismissible: DismissiblePane(
                                dismissThreshold: 0.3,
                                onDismissed:
                                    () => queueController.removeFromQueue(
                                      song.id,
                                    ),
                              ),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    queueController.removeFromQueue(song.id);
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SongtileSimple(
                                song: song,
                                heigt: 65,
                                width: 65,
                                songNameStyle: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontSize: 18),
                                artistNameStyle: Theme.of(
                                  context,
                                ).textTheme.titleLarge!.copyWith(fontSize: 15),
                                onTap: () => queueController.jumpToIndex(index),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          );
        }),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: Obx(() {
                  final isShuffled = queueController.isShuffled.value;
                  return ContainerIcon(
                    icon1: Icon(
                      CupertinoIcons.shuffle,
                      size: 30,
                      color:
                          isShuffled
                              ? (isDarkMode
                                  ? AColors.songTitleColor
                                  : AColors.songTitleColorDark)
                              : Colors.grey,
                    ),
                    height: 50,
                    width: double.infinity,
                    onTap: () {
                      queueController.toggleShuffle();
                    },
                    color:
                        isShuffled
                            ? (isDarkMode
                                ? AColors.darkGray3
                                : AColors.buttonDisabled)
                            : (isDarkMode
                                ? AColors.darkContainer
                                : AColors.inverseDarkGrey),
                  );
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() {
                  final color1 =
                      queueController.repeatMode.value == RepeatMode.off
                          ? isDarkMode
                              ? AColors.darkContainer
                              : AColors.inverseDarkGrey
                          : isDarkMode
                          ? AColors.darkGray3
                          : AColors.buttonDisabled;
                  final icon =
                      queueController.repeatMode.value == RepeatMode.one
                          ? CupertinoIcons.repeat_1
                          : CupertinoIcons.repeat;
                  final color =
                      queueController.repeatMode.value == RepeatMode.off
                          ? Colors.grey
                          : isDarkMode
                          ? AColors.songTitleColor
                          : AColors.songTitleColorDark;

                  return ContainerIcon(
                    icon1: Icon(icon, size: 30, color: color),
                    height: 50,
                    color: color1,
                    width: double.infinity,
                    onTap: queueController.toggleRepeatMode,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
