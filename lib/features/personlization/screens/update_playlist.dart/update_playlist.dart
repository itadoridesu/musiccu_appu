import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/images/rounded_images.dart';
import 'package:musiccu/features/musiccu/models/playlist_model/playlist_model.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';
import 'package:musiccu/utils/validators/validation.dart';

class UpdatePlaylistScreen extends StatelessWidget {
  const UpdatePlaylistScreen({super.key, required this.playlist});

  final PlaylistModel playlist;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

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
            // No controller for now
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Playlist Name Field
                _buildLabel(context, 'Playlist Name'),
                TextFormField(
                  initialValue: playlist.name,
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

                // Description Field (optional)
                _buildLabel(context, 'Description'),
                TextFormField(
                  initialValue: playlist.songIds.first,
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
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: RoundedImage(
                        imageUrl: playlist.coverImagePath ?? "",
                        height: 120,
                        width: 120,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Change Image'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Read-only Playlist ID
                _buildLabel(context, 'Playlist ID'),
                const SizedBox(height: 16),
                Text(
                  playlist.id,
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
          onPressed: () {},
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