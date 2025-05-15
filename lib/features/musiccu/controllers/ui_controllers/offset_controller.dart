import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

class OffsetController extends GetxController {
  static OffsetController get instance => Get.find();
  
  Rx<Offset> _tapPosition = Offset.zero.obs;

  // Get the current tap position
  Offset get tapPosition => _tapPosition.value;

  // Update the tap position whenever the user taps
  void updateTapPosition(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    _tapPosition.value = position;
  }
}
