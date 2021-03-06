import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = buildTheme();

final Color asoPrimary = Color(0xFFF30075);
final Color asoSecondary = Color(0xFFF30075);

ThemeData buildTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    textTheme:
        GoogleFonts.latoTextTheme(_buildDefaultTextTheme(base.textTheme)),
    primaryTextTheme: _buildDefaultTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildDefaultTextTheme(base.accentTextTheme),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: asoPrimary,
  );
}

TextTheme _buildDefaultTextTheme(TextTheme base) {
  return base.copyWith(
    headline4: base.headline4.copyWith(
      fontWeight: FontWeight.w800,
      color: Color(0xFF404040)
    ),
    headline5: base.headline5.copyWith(
      fontWeight: FontWeight.w500,
    ),
    headline6: base.headline6.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 25.0,
    ),
    caption: base.caption.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 18.0,
    ),
    bodyText1: base.bodyText1.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
    ),
  );
}
