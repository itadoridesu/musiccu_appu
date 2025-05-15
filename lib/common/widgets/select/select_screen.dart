import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiccu/common/widgets/select/selectable_tile.dart';
import 'package:musiccu/common/widgets/select/selection_bar.dart';
import 'package:musiccu/features/musiccu/controllers/selection_controller.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/helpers/helper_functions.dart';

class SelectionScreen<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) getId;
  final Widget Function(T) buildTile;
  final VoidCallback? onConfirm;
  final List<SelectionAction>? actions;
  final SelectionController<T>
  selectionController; // Receive controller as a parameter
  final Color? color;

  // Constructor to receive the controller
  const SelectionScreen({
    super.key,
    required this.items,
    required this.getId,
    required this.buildTile,
    this.onConfirm,
    this.actions, // Initialize the optional bottomNavBarWidget
    required this.selectionController, // Receive the selectionController
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final textColor = dark ? AColors.white : AColors.songTitleColorDark;

    return PopScope(
      canPop: false, // We'll handle popping manually
      onPopInvoked: (didPop) async {
        if (!didPop) {
          // Clear any replacement views before popping
          selectionController.replacementView.value == null ? Get.back() : selectionController.restoreDefaultView();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() {
            final count = selectionController.selectedIds.length;
            return Text(
              '$count selected',
              style: Theme.of(context).textTheme.headlineSmall,
            );
          }),
          leading: GestureDetector(
            onTap: () {
              selectionController.restoreDefaultView();
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(Icons.chevron_left, color: textColor),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Select All" row
              Obx(() {
                final allSelected =
                    selectionController.selectedIds.length == items.length;
                return Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: allSelected,
                        onChanged: (_) {
                          if (allSelected) {
                            selectionController.clearSelection();
                          } else {
                            final allIds = items.map(getId).toList();
                            selectionController.selectAll(allIds);
                          }
                        },
                        shape: const CircleBorder(),
                        side: BorderSide(color: AColors.artistTextColorDark),
                        checkColor: Colors.white,
                        activeColor: Colors.blue,
                      ),
                    ),
                    Text(
                      'Select All',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                );
              }),
      
              const SizedBox(height: 10),
      
              // Use ListView.builder inside a fixed-height Container
              ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // disables inner scroll
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final id = getId(item);
                  return Obx(
                    () => SelectableTile(
                      isSelected: selectionController.isSelected(id),
                      onToggle: () => selectionController.toggleSelection(id),
                      child: buildTile(item),
                      color: color ?? Colors.transparent,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      
        bottomNavigationBar:
            actions != null
                ? SelectionActionBar<T>(
                  // Now properly specifying the type
                  actions: actions!,
                  selectionController:
                      selectionController, // This now type-matches
                )
                : null,
      ),
    );
  }
}
