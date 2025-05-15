import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/features/musiccu/controllers/selection_controller.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class SelectionActionBar<T> extends StatelessWidget {
  final List<SelectionAction> actions;
  final SelectionController<T> selectionController;
  final Color activeColor;
  final Color inactiveColor;
  final double height;
  final double iconSize;
  final double labelFontSize;

  const SelectionActionBar({
    super.key,
    required this.actions,
    required this.selectionController,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.height = 70,
    this.iconSize = 26,
    this.labelFontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    
    return Obx(() {
      // Show replacement view if set
      if (selectionController.replacementView.value != null) {
        return selectionController.replacementView.value!;
      }

      final hasSelections = selectionController.selectedIds.isNotEmpty;
      final bgColor = dark ? const Color(0xFF2C2C2C) : AColors.songTitleColor;
      final disabledIconColor = dark ? Colors.grey[600] : Colors.grey[400];

      return Container(
        height: height,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: actions.map((action) {
            final isActive = hasSelections || action.alwaysActive;
            return _buildActionButton(
              context,
              icon: action.icon,
              label: action.label,
              isActive: isActive,
              activeColor: activeColor,
              inactiveColor: action.alwaysActive ? activeColor : disabledIconColor!,
              onPressed: isActive ? action.onPressed : null,
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: isActive ? activeColor : inactiveColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isActive ? activeColor : inactiveColor,
                      fontSize: labelFontSize,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectionAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool alwaysActive;

  const SelectionAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.alwaysActive = false,
  });
}