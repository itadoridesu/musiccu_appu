import 'package:flutter/material.dart';
import 'package:musiccu/common/widgets/container/container_text.dart';

class PlayShuffle extends StatelessWidget {
  const PlayShuffle({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ContainerText(
              text: "Play",
              icon: Icon(
                Icons.play_arrow_rounded,
                size: 28,
                color: Colors.blueAccent,
              ),
              onTap: () {
                
              },
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ContainerText(
              text: "Shuffle",
              icon: Icon(
                Icons.shuffle,
                size: 28,
                color: Colors.blue,
              ),
              onTap: () {
                // Shuffle action
              },
            ),
          ),
        ),
      ],
    );
  }
}

