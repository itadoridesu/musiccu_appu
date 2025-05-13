import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/features/personlization/controllers/theme_controller.dart';
import 'package:musiccu/utils/constants/colors.dart';

class TLoaders {
  static hideSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({
    required String message,
    Color? backgroundColor,
    double? horizontalMargin,
    SnackPosition? position,
  }) {
    final dark = ThemeController.instance.isDarkMode.value;

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor ?? (dark ? AColors.darkGray2 : AColors.songTitleColor),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: dark ? AColors.songTitleColor : AColors.songTitleColorDark,
            ),
          ),
        ),
      ),
    );
  }

  static successSnackBar({
    required String title,
    String message = '',
    int duration = 3,
    Color? backgroundColor,
    double? horizontalMargin,
    SnackPosition? position,
  }) {
    final dark = ThemeController.instance.isDarkMode();

    Get.snackbar(
      title,
      message,
      isDismissible: true,
      snackPosition: position ?? SnackPosition.TOP,
      duration: Duration(seconds: duration),
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 80, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      backgroundColor: backgroundColor ?? (dark ? AColors.dark : AColors.pageTitleColor),
      colorText: dark ? AColors.songTitleColor : AColors.songTitleColorDark,
      icon: Icon(Icons.check_circle, color: dark ? Colors.white : Colors.black, size: 20),
      shouldIconPulse: false,
    );
  }

  static warningSnackBar({
    required String title,
    String message = '',
    Color? backgroundColor,
    double? horizontalMargin,
    SnackPosition? position,
  }) {
    final dark = ThemeController.instance.isDarkMode.value;

    Get.snackbar(
      title,
      message,
      isDismissible: true,
      snackPosition: position ?? SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 80, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      backgroundColor: backgroundColor ?? (dark ? AColors.darkGray2 : AColors.artistTextColor),
      colorText: dark ? AColors.songTitleColor : AColors.songTitleColorDark,
      icon: Icon(Icons.warning_amber_rounded, color: dark ? Colors.white : Colors.black, size: 20),
      shouldIconPulse: false,
    );
  }

  static errorSnackBar({
    required String title,
    String message = '',
    Color? backgroundColor,
    double? horizontalMargin,
    SnackPosition? position,
  }) {
    final dark = ThemeController.instance.isDarkMode.value;

    Get.snackbar(
      title,
      message,
      isDismissible: true,
      snackPosition: position ?? SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 80, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      backgroundColor: backgroundColor ?? (dark ? AColors.darkGray2 : AColors.artistTextColor),
      colorText: dark ? AColors.songTitleColor : AColors.songTitleColorDark,
      icon: Icon(Icons.error_outline, color: dark ? Colors.white : Colors.black, size: 20),
      shouldIconPulse: false,
    );
  }
}
