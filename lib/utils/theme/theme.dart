
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musiccu/utils/constants/colors.dart';
import 'package:musiccu/utils/theme/custom_theme/appbar_theme.dart' show TAppBarTheme;
import 'package:musiccu/utils/theme/custom_theme/buttom_sheet_theme.dart';
import 'package:musiccu/utils/theme/custom_theme/checkbox_theme.dart';
import 'package:musiccu/utils/theme/custom_theme/chip_theme.dart';
import 'package:musiccu/utils/theme/custom_theme/elevated_button_theme.dart';
import 'package:musiccu/utils/theme/custom_theme/outlined_button_theme.dart';
import 'package:musiccu/utils/theme/custom_theme/text_field_theme.dart';
import 'package:musiccu/utils/theme/custom_theme/text_theme.dart';





class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.poppins().fontFamily,
    disabledColor: Colors.grey,
    brightness: Brightness.light,
    primaryColor: AColors.artistTextColor,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.poppins().fontFamily,
    disabledColor: Colors.grey,
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}
