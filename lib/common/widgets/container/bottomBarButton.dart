import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/features/musiccu/controllers/selection_controller.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class BottomBarButton<T> extends StatelessWidget {
  const BottomBarButton({
    super.key,
    required this.context,
    required this.onTap,
    this.text = 'Delete',
    this.color = Colors.red,
    required this.selectionController,
  });

  final BuildContext context;
  final VoidCallback onTap;
  final String text;
  final Color color;
  final SelectionController<T> selectionController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasSelections = selectionController.selectedIds.isNotEmpty;
      final dark = THelperFunctions.isDarkMode(context);
      final bgColor = dark ? const Color(0xFF2C2C2C) : AColors.songTitleColor;
      final textColor = dark ? Colors.grey[600]! : Colors.grey[400]!;

      final effectiveBgColor = hasSelections ? color : bgColor;
      final effectiveTextColor = hasSelections ? Colors.white : textColor;

      return Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 57,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: hasSelections? onTap : () {},
            style: ElevatedButton.styleFrom(
              shadowColor: hasSelections ? null: Colors.transparent,

              backgroundColor: effectiveBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ).copyWith(
              side: MaterialStateProperty.all(BorderSide.none),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: effectiveTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
      );
    });
  }
}
