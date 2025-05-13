import 'package:flutter/material.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';

class PlaylistTileSimple extends StatelessWidget {
  const PlaylistTileSimple({
    super.key,
    required this.playlist,
    this.heigt = 60,
    this.width = 60,
    this.onTap,
  });

  final PlaylistModel playlist;
  final double heigt, width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias, // required for ripple to clip to radius
      borderRadius: BorderRadius.circular(20), // This controls ripple shape
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RoundedImage(
              imageUrl: playlist.coverImagePath ?? "",
              height: heigt,
              width: width,
              applyImageRadius: true,
              borderRadius: 17,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    "${playlist.songIds.length} songs",
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
