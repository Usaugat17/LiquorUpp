// define app theme here

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquor_inventory/utils/config/palette.dart';

class AppTheme {
  static TextTheme lightThemeText = TextTheme(
    bodyText1: GoogleFonts.raleway(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: Palette.primaryRed,
    ),
    bodyText2: GoogleFonts.raleway(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      color: Palette.primaryRed,
    ),
    headline1: GoogleFonts.readexPro(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline2: GoogleFonts.readexPro(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Palette.primaryRed,
      textTheme: lightThemeText,
    );
  }
}
