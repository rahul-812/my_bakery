import 'package:flutter/material.dart';
import 'colors.dart';

class CustomTheme {
  /// Dark Theme
  static ThemeData get light {
    return ThemeData.light(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(primary: LightColors.main),
      appBarTheme: const AppBarTheme(
        // shape: Border(
        //   bottom: BorderSide(color: LightColors.greyCard, width: 1),
        // ),
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
      listTileTheme: ListTileThemeData(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
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
      dividerTheme:
          const DividerThemeData(color: Color(0xffedeef1), space: 0.0),
      dialogTheme: const DialogTheme(elevation: 0.0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: LightColors.main,
      ),
      tabBarTheme: const TabBarTheme(
        splashFactory: InkRipple.splashFactory,
        // labelColor: const Color(0xffbe500f),
        labelColor: LightColors.text,
        unselectedLabelColor: LightColors.lightText,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: EdgeInsets.symmetric(horizontal: 12.0),
        // indicator: BoxDecoration(
        //   color: Colors.black87,
        //   borderRadius: BorderRadius.circular(8.0),
        // ),
        indicatorColor: LightColors.main,
      ),
    );
  }
}
