import 'dart:io';
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

void showEnlargedImage(String imagePath) {
  Get.to(
    fullscreenDialog: true,
    () => Scaffold(
      backgroundColor: Colors.black.withOpacity(0.95),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              width: 150,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
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
