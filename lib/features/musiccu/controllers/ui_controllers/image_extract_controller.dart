// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:palette_generator/palette_generator.dart';

// class ImageColorController extends GetxController {
//   static ImageColorController get instance => Get.find();
  
   
//   var extractedColor = Colors.transparent.obs;
//   var lightColor = Colors.transparent.obs;

//   // Method to extract the colors from the image
//   void extractColors(String imageUrl) async {
//     final palette = await PaletteGenerator.fromImageProvider(
//       AssetImage(imageUrl), 
//     );
    
//     // Extract the dominant and vibrant color
//     extractedColor.value = palette.dominantColor?.color ?? Colors.transparent;
//     lightColor.value = palette.vibrantColor?.color ?? Colors.transparent;
//   }
// }
