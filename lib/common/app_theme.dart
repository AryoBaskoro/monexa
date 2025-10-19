import 'package:flutter/material.dart';
import 'color_extension.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    fontFamily: "Inter",
    useMaterial3: false,
    brightness: Brightness.light,
    primaryColor: TColor.primary,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light gray background
    colorScheme: ColorScheme.light(
      primary: TColor.primary,
      secondary: TColor.secondary,
      surface: Colors.white,
      background: const Color(0xFFF5F5F5), // Light gray background
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: TColor.primary,
      unselectedItemColor: TColor.gray40,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    fontFamily: "Inter",
    useMaterial3: false,
    brightness: Brightness.dark,
    primaryColor: TColor.primary,
    scaffoldBackgroundColor: const Color(0xff0A0A0F),
    colorScheme: ColorScheme.dark(
      primary: TColor.primary,
      secondary: TColor.secondary,
      surface: const Color(0xff1A1A24),
      background: const Color(0xff0A0A0F),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xff1A1A24),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xff1A1A24),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xff1A1A24),
      selectedItemColor: TColor.primary,
      unselectedItemColor: TColor.gray40,
    ),
  );

  // Helper methods to get theme-aware colors
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff0A0A0F)
        : const Color(0xFFF5F5F5); // Light gray background
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff1A1A24)
        : Colors.white;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? TColor.gray30
        : TColor.gray60;
  }

  static Color getNavBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff1A1A24)
        : Colors.white;
  }

  static Color getChartBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff1A1A24).withOpacity(0.5)
        : Colors.white.withOpacity(0.8); // Light background for charts
  }
}
