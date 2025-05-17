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
  final VoidCallback? onGetBack;
  final List<SelectionAction>? actions;
  final SelectionController<T> selectionController;
  final Color? color, selectionColor;
  final double distance, padding;
  final bool showSearch;

  const SelectionScreen({
    super.key,
    required this.items,
    required this.getId,
    required this.buildTile,
    this.onGetBack,
    this.actions,
    required this.selectionController,
    this.color,
    this.distance = 2,
    this.selectionColor,
    this.padding = 10,
    this.showSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final textColor = dark ? AColors.white : AColors.songTitleColorDark;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          if (onGetBack != null) {
            onGetBack!();
          } else if (selectionController.replacementView.value == null) {
            selectionController.clearSelection();
            Get.back();
          } else {
            selectionController.restoreDefaultView();
          }
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
              if (onGetBack != null)
                onGetBack!();
              else {
                selectionController.clearSelection();
                Get.back();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(Icons.chevron_left, color: textColor),
            ),
          ),
        ),
        body: Column(
          children: [
            // Add search bar if showSearch is true
            if (showSearch)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 10,
                ),
                child: Builder(
                  builder: (context) {
                    final dark =
                        Theme.of(context).brightness == Brightness.dark;
                    final borderColor =
                        dark ? Colors.grey : Colors.grey.shade400;
                    final focusedBorderColor =
                        dark ? Colors.grey.shade300 : Colors.grey.shade800;

                    return TextField(
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                      ),
                      onChanged: (value) {
                        // your search logic
                      },
                      decoration: InputDecoration(
                        hintText: 'Search songs...',
                        hintStyle: TextStyle(
                          color: dark ? Colors.grey[400] : Colors.grey[700],
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: dark ? Colors.white : Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: focusedBorderColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 5,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Select All" row
                    Obx(() {
                      final allSelected =
                          selectionController.selectedIds.length ==
                          items.length;
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
                              side: BorderSide(
                                color: AColors.artistTextColorDark,
                              ),
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

                    // ListView.builder
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final id = getId(item);
                        return Obx(
                          () => SelectableTile(
                            isSelected: selectionController.isSelected(id),
                            onToggle:
                                () => selectionController.toggleSelection(id),
                            child: buildTile(item),
                            color: color ?? Colors.transparent,
                            distance: distance,
                            selectionColor:
                                selectionColor ?? Colors.blue.withOpacity(0.1),
                            padding: padding,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        bottomNavigationBar:
            actions != null
                ? SelectionActionBar<T>(
                  actions: actions!,
                  selectionController: selectionController,
                )
                : null,
      ),
    );
  }
}
