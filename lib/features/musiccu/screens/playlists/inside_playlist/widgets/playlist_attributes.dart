import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/features/musiccu/controllers/playlist/playlists_controller.dart';
import 'package:musiccu/features/personlization/screens/update_playlist.dart/update_playlist.dart';
import 'package:musiccu/utils/constants/colors.dart';

class PlaylistAttributes extends StatelessWidget {
  const PlaylistAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistController = PlaylistController.instance;
    final playlist = playlistController.selectedPlaylist.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          ()=> RoundedImage(
            imageUrl: playlistController.selectedPlaylist.value!.coverImagePath ?? "",
            height: 250,
            width: 250,
          ),
        ),
        const SizedBox(height: 10),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250), // Match image width
          child: IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min, // Take only needed space
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    playlist.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis, // Handle overflow
                    maxLines: 1, // Single line
                  ),
                ),
                if (playlist.id != 'predef_recently_played' &&
                    playlist.id != 'predef_most_played') ...[
                  IconButton(
                    icon: const Icon(
                      Icons.edit_sharp,
                      size: 20,
                      color: AColors.artistTextColor,
                    ),
                    onPressed: () {
                      Get.to(UpdatePlaylistScreen(playlist: playlist));
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
        Text(
          "${playlist.songIds.length} songs",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
