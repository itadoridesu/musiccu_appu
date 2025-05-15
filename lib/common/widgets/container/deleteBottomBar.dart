import 'package:flutter/material.dart';

class DeleteBottomBar extends StatelessWidget {
  const DeleteBottomBar({
    super.key,
    required this.context,
    required this.onTap
  });

  final BuildContext context;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias, // required for ripple to clip to radius
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}