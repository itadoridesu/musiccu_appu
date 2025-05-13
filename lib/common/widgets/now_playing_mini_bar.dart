import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:musiccu/common/widgets/glassmorhphism/glass_effect_container.dart';
import 'package:musiccu/common/widgets/tiles/song_tile.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';

class NowPlayingMiniBar extends StatelessWidget {
  const NowPlayingMiniBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SongController.instance;
    return Obx(() {
     final selected = controller.selectedSong.value;
     if (selected == null) return SizedBox.shrink();
    
     // hero tags only fire on showIcon=false
     return GlassEffectContainer(
       child: Padding(
         padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
         child: SongTile(
           song: selected,
           showIcon: false,            
           isPauseStop: true,
         ),
       ),
     );
          });
  }
}
