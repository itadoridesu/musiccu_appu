import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class LyricsContainer extends StatelessWidget {
  const LyricsContainer({super.key, required this.lyrics});

  final String lyrics;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Hero(
      tag: "Up - Next", // Hero transition tag
      child: Container(
        width: double.infinity,
        height: 460,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: dark ? AColors.darkContainer : AColors.inverseDarkGrey,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.music_note_2,
                    color: dark ? AColors.inverseDarkGrey : AColors.textPrimary,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Lyrics',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 18,
                      color:
                          dark ? AColors.songTitleColor : AColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),

              // Displaying the actual lyrics
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      dark ? AColors.songTitleColor : AColors.textPrimary,
                      (dark ? AColors.songTitleColor : AColors.textPrimary)
                          .withOpacity(0.1),
                    ],
                    stops: [0.0, 1.0], 
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Text(
                  lyrics,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
