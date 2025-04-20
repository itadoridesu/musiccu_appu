import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart'; // Assuming AColors is defined here

class TLoaders {
  static hideSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({required String message}) {
    final dark = THelperFunctions.isDarkMode(Get.context!);

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          margin: const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: dark ? AColors.darkGray2 : AColors.artistTextColor,
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: dark ? AColors.songTitleColor : AColors.songTitleColorDark,
            ),
          ),
        ),
      ),
    );
  }

  static successSnackBar({required String title, String message = '', int duration = 3}) {
    final dark = THelperFunctions.isDarkMode(Get.context!);

    Get.snackbar(
      title,
      message,
      isDismissible: true,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      backgroundColor: dark ? AColors.dark : AColors.pageTitleColor,
      colorText: dark ? AColors.songTitleColor : AColors.songTitleColorDark,
      icon: Icon(Icons.check_circle, color: dark ? Colors.white : Colors.black, size: 20),
      shouldIconPulse: false,
    );
  }

  static warningSnackBar({required String title, String message = ''}) {
    final dark = THelperFunctions.isDarkMode(Get.context!);

    Get.snackbar(
      title,
      message,
      isDismissible: true,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      backgroundColor: dark ? AColors.darkGray2 : AColors.artistTextColor,
      colorText: dark ? AColors.songTitleColor : AColors.songTitleColorDark,
      icon: Icon(Icons.warning_amber_rounded, color: dark ? Colors.white : Colors.black, size: 20),
      shouldIconPulse: false,
    );
  }

  static errorSnackBar({required String title, String message = ''}) {
    final dark = THelperFunctions.isDarkMode(Get.context!);

    Get.snackbar(
      title,
      message,
      isDismissible: true,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      backgroundColor: dark ? AColors.darkGray2 : AColors.artistTextColor,
      colorText: dark ? AColors.songTitleColor : AColors.songTitleColorDark,
      icon: Icon(Icons.error_outline, color: dark ? Colors.white : Colors.black, size: 20),
      shouldIconPulse: false,
    );
  }
}
