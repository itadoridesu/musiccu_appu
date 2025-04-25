import 'package:flutter/material.dart';
import 'package:musiccu/features/musiccu/controllers/playlists_controller.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class AddNew extends StatelessWidget {
  const AddNew({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () => PlaylistController.instance.showCreatePlaylistDialog(),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: dark ? const Color.fromARGB(255, 31, 30, 30)
                : AColors.songTitleColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 32),
              Text(
                "Add new",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}