import 'package:get/get.dart';

class MusicBarController extends GetxController {
  static MusicBarController get instace => Get.find();

  var isVisible = false.obs; // Observable boolean for visibility

  @override
  void onInit() {
    super.onInit();
    _toggleVisibility(); // Call the method to toggle visibility when the controller is initialized
  }

  void _toggleVisibility() async {
    await Future.delayed(Duration(milliseconds: 600)); // Delay before showing the widget
    isVisible.value = true; // Set visibility to true after delay
  }
}
