import 'package:get/get.dart';
import 'package:musiccu/data/repositories/songs_repository.dart';
import 'package:musiccu/features/musiccu/controllers/songs_controller.dart';
import 'package:musiccu/features/musiccu/models/song_model/song_model.dart';
import 'package:musiccu/features/personlization/controllers/theme_controller.dart';

class FavoriteController extends GetxController {
  static FavoriteController get instance => Get.find();

  final SongRepository _songRepository = SongRepository.instance;
  final RxList<SongModel> favoriteSongs = <SongModel>[].obs;

  /// Keeps track of favorite status reactively for each song
  final Map<String, RxBool> favoriteStatusMap = {};


  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    favoriteSongs.assignAll(SongController.instance.songs.where((song) => song.isFavorite));

    // Fill map with current favorite statuses
    for (var song in favoriteSongs) {
      favoriteStatusMap[song.id] = song.isFavorite.obs;
    }
  }

  void toggleFavorite(SongModel song) {
  final rx = isFavoriteRx(song);
  rx.value = !rx.value;
  song.isFavorite = rx.value;
  _songRepository.updateSong(song);
}

  RxBool isFavoriteRx(SongModel song) {
    return favoriteStatusMap[song.id] ??= song.isFavorite.obs;
  }
}

