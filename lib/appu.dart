import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:musiccu/features/musiccu/screens/songs/songs.dart';
import 'package:musiccu/features/personlization/controllers/theme_controller.dart';
import 'package:musiccu/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeController()); // Initialize controller
    
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeController.instance.isDarkMode.value 
          ? ThemeMode.dark 
          : ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const SongsScreen(),
    ));
  }
}