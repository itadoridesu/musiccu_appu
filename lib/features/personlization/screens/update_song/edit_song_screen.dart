import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/appbar/app_bar.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/features/musiccu/controllers/image_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/personlization/controllers/edit_song_controller.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';
import 'package:musiccu/utils/validators/validation.dart';

class EditSongScreen extends StatelessWidget {
  const EditSongScreen({super.key, required this.song});

  final SongModel song;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditSongController());
    controller.init(song);

    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Song'),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: dark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: controller.editSongFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Field
                _buildLabel(context, 'Name'),
                TextFormField(
                  controller: controller.songName,
                  validator:
                      (value) => TValidator.validateEmptyText('Name', value),
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.red[700]),
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.withOpacity(0.4),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Artist Field
                _buildLabel(context, 'Artist'),
                TextFormField(
                  controller: controller.artist,
                  validator:
                      (value) => TValidator.validateEmptyText('Artist', value),
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.red[700]),
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.withOpacity(0.4),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Album Field (optional - no validation)
                _buildLabel(context, 'Album'),
                TextFormField(
                  controller: controller.album,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue.withOpacity(0.4),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Cover Image
                _buildLabel(context, 'Cover'),
                const SizedBox(height: 18),
                Obx(() {
                  final imagePath = controller.newImagePath.value;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (imagePath != null && imagePath!.isNotEmpty) {
                            ImageController.instance.showEnlargedImage(
                              imagePath,
                            );
                          }
                        },
                        child: RoundedImage(
                          imageUrl: imagePath ?? "",
                          height: 120,
                          width: 120,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.pickNewCoverImage,
                        child: const Text('Change Image'),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 30),

                // Read-only File Path
                _buildLabel(context, 'File Path'),
                const SizedBox(height: 16),
                Text(
                  song.audioUrl,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => controller.saveSongChanges(),
          child: const Text('Save'),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(
          context,
        ).textTheme.headlineSmall?.color?.withOpacity(0.8),
      ),
    );
  }
}
