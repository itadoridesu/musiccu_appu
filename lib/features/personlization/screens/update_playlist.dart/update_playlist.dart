import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/features/musiccu/controllers/ui_controllers/image_controller.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/features/personlization/controllers/edit_playlist_controller.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';
import 'package:musiccu/utils/validators/validation.dart';


class UpdatePlaylistScreen extends StatelessWidget {
  const UpdatePlaylistScreen({super.key, required this.playlist});

  final PlaylistModel playlist;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(EditPlaylistController());
    controller.init(playlist);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Playlist'),
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
            key: controller.editPlaylistFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Playlist Name Field
                _buildLabel(context, 'Playlist Name'),
                TextFormField(
                  controller: controller.playlistName,
                  validator: (value) => TValidator.validateEmptyText('Playlist Name', value),
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

                // Cover Image
                _buildLabel(context, 'Cover'),
                const SizedBox(height: 18),
                Obx(() {
                  final imagePath = controller.newCoverImagePath.value ?? playlist.coverImagePath;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: imagePath != null && imagePath.isNotEmpty 
                            ? () => ImageController.instance.showEnlargedImage(imagePath)
                            : null,
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: controller.savePlaylistChanges,
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
        color: Theme.of(context).textTheme.headlineSmall?.color?.withOpacity(0.8),
      ),
    );
  }
}