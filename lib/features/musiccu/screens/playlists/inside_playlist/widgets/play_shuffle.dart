import 'package:flutter/material.dart';
import 'package:musiccu/common/widgets/container/container_text.dart';
import 'package:musiccu/features/musiccu/controllers/que_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';

class PlayShuffle extends StatelessWidget {
  const PlayShuffle({
    super.key, required this.songs,
  });

  final List<SongModel> songs;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ContainerText(
              text: "Play",
              icon: Icon(
                Icons.play_arrow_rounded,
                size: 28,
                color: Colors.blueAccent,
              ),
              onTap: () => QueueController.instance.playPlaylist(songs, context),
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 25),
            child: ContainerText(
              text: "Shuffle",
              icon: Icon(
                Icons.shuffle,
                size: 28,
                color: Colors.blue,
              ),
              onTap: () => QueueController.instance.shufflePlaylist(songs, context),
            ),
          ),
        ),
      ],
    );
  }
}

