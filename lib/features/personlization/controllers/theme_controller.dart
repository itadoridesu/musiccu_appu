import 'package:hive/hive.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  final RxBool isDarkMode = false.obs;
  static const String _themeKey = 'is_dark_mode';
  late final Box _themeBox;

  @override
  void onInit() {
    _themeBox =  Hive.box('theme_preferences');
    _loadTheme();
    super.onInit();
  }

  Future<void> _loadTheme() async {
    isDarkMode.value = _themeBox.get(_themeKey, defaultValue: Get.isPlatformDarkMode);
  }

  Future<void> toggleTheme() async {
    isDarkMode.toggle();
    await _themeBox.put(_themeKey, isDarkMode.value);
  }

}