import 'package:get/get.dart';

class LyricsController extends GetxController {
  static LyricsController get instance => Get.find();

  Rx<bool> isLyrics = false.obs;

  // fetch lyrics method and put it in init

  void togglyrics() {

    try {

      isLyrics.toggle();


    } catch (e) { 
      Get.snackbar("Lyrics", "No lyrics available for this song :(");
    }
  }
 }