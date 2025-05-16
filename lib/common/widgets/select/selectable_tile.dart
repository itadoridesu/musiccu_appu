import 'package:flutter/material.dart';
import 'package:musiccu/utils/constants/colors.dart';

class SelectableTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onToggle;
  final Widget child;
  final Color color, selectionColor;
  final double distance, padding;

  const SelectableTile({
    super.key,
    required this.isSelected,
    required this.onToggle,
    required this.child,
    required this.color,
    required this.distance,
    required this.selectionColor,
    required this.padding
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias, // required for ripple to clip to radius
        child: InkWell(
          onTap: onToggle,
          child: Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: isSelected ? selectionColor : color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 1.2, // Adjust this to make it larger or smaller
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => onToggle(),
                    shape: const CircleBorder(),
                    side: BorderSide(color: AColors.artistTextColorDark),
                    checkColor: Colors.white,
                    activeColor: Colors.blue,
                  ),
                ),
                SizedBox(width: distance),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
