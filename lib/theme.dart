import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        bodyLarge: TextStyle(
          color: LightColors.text,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
        ),
        bodyMedium: TextStyle(
          color: LightColors.textMedium,
          letterSpacing: 0.0,
        ),
        bodySmall: TextStyle(color: LightColors.lightText),
      ),
      iconTheme: const IconThemeData(color: LightColors.main),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: Color(0xffc0c3cb)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: LightColors.main),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xffedeef1),
      ),
      dialogTheme: const DialogTheme(elevation: 0.0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: LightColors.main,
      ),
      tabBarTheme: TabBarTheme(
        splashFactory: InkRipple.splashFactory,
        // labelColor: const Color(0xffbe500f),
        labelColor: LightColors.text,
        unselectedLabelColor: LightColors.lightText,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        indicator: BoxDecoration(
          color: LightColors.greyCard,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
