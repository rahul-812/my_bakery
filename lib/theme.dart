import 'package:flutter/material.dart';
import 'colors.dart';

class CustomTheme {
  /// Dark Theme
  static ThemeData get light {
    return ThemeData.light(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(primary: LightColors.main),
      appBarTheme: const AppBarTheme(
        toolbarHeight: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: LightColors.black),
        bodyMedium: TextStyle(color: LightColors.darkGrey),
        bodySmall: TextStyle(color: LightColors.greyM),
      ),
      dialogTheme: const DialogTheme(elevation: 0.0),
      dividerColor: const Color(0xffccd8e8),
    );
  }
}
