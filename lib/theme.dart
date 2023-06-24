import 'package:flutter/material.dart';
import 'colors.dart';

class CustomTheme {
  /// Dark Theme
  static ThemeData get light {
    return ThemeData.light(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(primary: LightColors.main),
      appBarTheme: const AppBarTheme(
        // toolbarHeight: 0.0,
        shape: Border(
          bottom: BorderSide(color: Color(0xFFDDDFE0), width: 1),
        ),
        scrolledUnderElevation: 0.0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: LightColors.black),
        bodyMedium: TextStyle(color: LightColors.darkGrey),
        bodySmall: TextStyle(color: LightColors.greyM),
      ),
      dialogTheme: const DialogTheme(elevation: 0.0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: LightColors.secondary,
      ),
    );
  }
}
