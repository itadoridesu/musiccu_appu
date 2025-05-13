import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/features/musiccu/controllers/que_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/features/musiccu/controllers/que_controller.dart';

class PageViewController extends GetxController {
  static PageViewController get instance => Get.find();
  
  late final PageController pageController;
  final isUserScrolling = false.obs;
  final isProcessingQueueChange = false.obs;
  final _disposed = false.obs;
  final QueueController _queueController = QueueController.instance;

  @override
  void onInit() {
    super.onInit();
    _initController();
    _setupListeners();
  }

  void _initController() {
    if (!_disposed.value) {
      pageController = PageController(
        initialPage: _queueController.currentIndex.value,
        viewportFraction: 1.0,
      );
    }
  }

  void _setupListeners() {
    ever(_queueController.currentIndex, _handleIndexChange);
  }

  void _handleIndexChange(int newIndex) {
    if (!_disposed.value && 
        !isUserScrolling.value && 
        !isProcessingQueueChange.value &&
        pageController.hasClients &&
        newIndex != pageController.page?.round()) {
      pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // New: Handles shuffle operation with visual safety
  Future<void> handleShuffle() async {
    if (_disposed.value) return;
    isProcessingQueueChange.value = true;
    _queueController.toggleShuffle();
    safeJumpToPage(_queueController.currentIndex.value);
    isProcessingQueueChange.value = false;
  }

  // New: Handles unshuffle operation with visual safety
  Future<void> handleUnshuffle() async {
    if (_disposed.value) return;
    isProcessingQueueChange.value = true;
    final currentSongId = _queueController.currentSong?.id;
    _queueController.toggleShuffle();
    if (currentSongId != null) {
      final newIndex = _queueController.queue.indexWhere((s) => s.id == currentSongId);
      safeJumpToPage(newIndex);
    }
    isProcessingQueueChange.value = false;
  }

  void handlePageChanged(int index) {
    if (_disposed.value) return;
    isUserScrolling.value = true;
    _queueController.jumpToIndex(index);
    isUserScrolling.value = false;
  }

  // Safe wrapper for page jumps
  void safeJumpToPage(int index) {
    if (!_disposed.value && pageController.hasClients) {
      pageController.jumpToPage(index);
    }
  }

  @override
  void onClose() {
    _disposed.value = true;
    pageController.dispose();
    super.onClose();
  }
}