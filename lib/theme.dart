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
        bodyLarge: TextStyle(color: LightColors.textColor),
        bodyMedium: TextStyle(color: LightColors.textMediumColor),
        bodySmall: TextStyle(color: LightColors.lightTextColor),
      ),
      shadowColor: const Color(0x230054FF),
      dividerColor: const Color(0xffedeef1),
      dialogTheme: const DialogTheme(elevation: 0.0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: LightColors.secondary,
      ),
      splashFactory: InkRipple.splashFactory,
      tabBarTheme: TabBarTheme(
        labelColor: const Color(0xffbe500f),
        unselectedLabelColor: LightColors.lightTextColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.all(12.0),
        indicator: BoxDecoration(
          color: const Color(0xffffe1d0),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
