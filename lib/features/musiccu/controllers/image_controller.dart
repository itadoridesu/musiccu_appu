import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageController extends GetxController 
    with GetSingleTickerProviderStateMixin {
  static ImageController get instance => Get.find();
  
  late AnimationController rotationController;
  final RxDouble currentAngle = 0.0.obs;
  final RxBool isRotating = false.obs;

  @override
  void onInit() {
    super.onInit();
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        currentAngle.value = rotationController.value * 2 * pi;
      });
  }

  /// Handles rotation state with proper frame scheduling
  void handleRotation(bool shouldRotate) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shouldRotate) {
        if (!isRotating.value) {
          rotationController.repeat();
          isRotating.value = true;
        }
      } else {
        if (isRotating.value) {
          rotationController.stop();
          isRotating.value = false;
        }
      }
    });
  }

  @override
  void onClose() {
    rotationController.dispose();
    super.onClose();
  }
}