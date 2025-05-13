// lib/services/navigation_safety_service.dart
import 'package:get/get.dart';

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();
  
  final RxBool _isNavigating = false.obs;
  
  bool get isNavigating => _isNavigating.value;
  
  void blockNavigation() => _isNavigating.value = true;
  
  void allowNavigation() => _isNavigating.value = false;
  
  bool handleNavigation() {
    if (isNavigating) return false;
    blockNavigation();
    return true;
  }
}