import 'package:flutter/material.dart';
import 'colors.dart';

class CustomTheme {
  /// Dark Theme
  static ThemeData get light {
    const errorBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: Colors.redAccent),
    );

    return ThemeData.light(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(primary: LightColors.main),
      appBarTheme: const AppBarTheme(
        toolbarHeight: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: LightColors.text,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          letterSpacing: 0.0,
        ),
        bodyMedium: TextStyle(
          color: LightColors.textMedium,
          fontFamily: 'Inter',
          letterSpacing: 0.0,
        ),
        bodySmall: TextStyle(
          color: LightColors.lightText,
          fontFamily: 'Inter',
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 6.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      iconTheme: const IconThemeData(color: LightColors.main),
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: LightColors.main),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffc0c3cb)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 14.0,
        ),
        hintStyle: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
          color: LightColors.lightText,
          fontFamily: 'Inter',
        ),
        labelStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: LightColors.lightText,
          fontFamily: 'Inter',
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.transparent,
        space: 0.0,
      ),
      dialogTheme: const DialogTheme(elevation: 0.0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: LightColors.text,
        unselectedItemColor: LightColors.textMedium,
        selectedLabelStyle: TextStyle(
          fontSize: 13.0,
          fontFamily: 'Inger',
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 13.0, fontFamily: 'Inger'),
      ),
      tabBarTheme: TabBarTheme(
        splashFactory: InkRipple.splashFactory,
        labelColor: Colors.white,
        unselectedLabelColor: LightColors.main,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 25.0),
        indicator: BoxDecoration(
          color: LightColors.main,
          borderRadius: BorderRadius.circular(50.0),
        ),
        dividerColor: Colors.transparent,
      ),
    );
  }
}
