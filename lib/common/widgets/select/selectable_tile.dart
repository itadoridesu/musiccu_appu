import 'package:flutter/material.dart';
import 'package:musiccu/utils/constants/colors.dart';

class SelectableTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onToggle;
  final Widget child;
  final Color? color;

  const SelectableTile({
    super.key,
    required this.isSelected,
    required this.onToggle,
    required this.child,
    this.color,
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
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.withOpacity(0.1) : color,
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
                const SizedBox(width: 8),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
