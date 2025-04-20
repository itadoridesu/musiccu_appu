import 'dart:io';

import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor = Colors.transparent,
    this.fit = BoxFit.cover,
    this.padding,
    this.onPressed,
    this.borderRadius = 25,
    this.showShadow = false,
    this.shadow = const BoxShadow(  
      color: Colors.black26,
      blurRadius: 10.0,
      offset: Offset(0, 4),
    ),
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final double borderRadius;
  final bool showShadow; 
  final BoxShadow shadow; 

  @override
  Widget build(BuildContext context) {
    // Check if imageUrl is a valid path and exists on the device
    String imageToShow = imageUrl.isNotEmpty && File(imageUrl).existsSync()
        ? imageUrl
        : 'assets/no_music.png'; // fallback to default image if not valid

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: showShadow ? [shadow] : [], 
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
          child: File(imageToShow).existsSync()
              ? Image.file(
                  File(imageToShow),
                  fit: fit,
                )
              : Image.asset(
                  imageToShow,
                  fit: fit,
                ),
        ),
      ),
    );
  }
}
