import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_tracker/ui/theme/colors.dart';

final ThemeData defaultTheme = _buildDefaultTheme();

ThemeData _buildDefaultTheme() {
  final ThemeData base = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xffb8f512),
    textTheme: GoogleFonts.muliTextTheme(),
  );
  return base.copyWith(
      textTheme: _buildDefaultTextTheme(base.textTheme)
          .apply(bodyColor: Colors.white, displayColor: Colors.grey),
      primaryTextTheme: _buildDefaultTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildDefaultTextTheme(base.accentTextTheme),
      textSelectionHandleColor: WTColors.limeGreen);
}

TextTheme _buildDefaultTextTheme(TextTheme base) {
  return base.copyWith();
}
