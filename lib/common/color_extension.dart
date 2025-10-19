import 'package:flutter/material.dart';

class TColor {
  static Color get primary => const Color(0xff5E00F5);
  static Color get primary500 => const Color(0xff7722FF );
  static Color get primary20 => const Color(0xff924EFF);
  static Color get primary10 => const Color(0xffAD7BFF);
  static Color get primary5 => const Color(0xffC9A7FF);
  static Color get primary0 => const Color(0xffE4D3FF);

  static Color get secondary => const Color(0xffFF7966);
  static Color get secondary50 => const Color(0xffFFA699);
  static Color get secondary0 => const Color(0xffFFD2CC);

  static Color get secondaryG => const Color(0xff00FAD9);
  static Color get secondaryG50 => const Color(0xff7DFFEE);

  static Color get gray => const Color(0xff0E0E12);
  static Color get gray80 => const Color(0xff1C1C23);
  static Color get gray70 => const Color(0xff353542);
  static Color get gray60 => const Color(0xff4E4E61);
  static Color get gray50 => const Color(0xff666680);
  static Color get gray40 => const Color(0xff83839C);
  static Color get gray30 => const Color(0xffA2A2B5);
  static Color get gray20 => const Color(0xffC1C1CD);
  static Color get gray10 => const Color(0xffE0E0E6);

  static Color get border => const Color(0xffCFCFFC);
  static Color get primaryText => Colors.white;
  static Color get secondaryTextColor => gray60;
  
  static Color get white => Colors.white;
  
  // Theme-aware color getters
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff0A0A0F) // Dark background
        : const Color(0xFFF5F5F5); // Light gray background
  }
  
  static Color card(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff1A1A24)
        : Colors.white;
  }
  
  static Color text(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
  
  static Color header(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff1A1A24).withOpacity(0.5)
        : Colors.white.withOpacity(0.95); // More opaque white for better visibility
  }
  
  static Color cardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff2A2A3A).withOpacity(0.5)
        : Colors.white.withOpacity(0.8); // Light card background
  }
  
  // Additional theme-aware helpers for UI elements
  static Color secondaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray30
        : gray50; // Darker gray for better contrast in light mode
  }
  
  static Color tertiaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray40
        : gray60; // Darker for light mode
  }
  
  static Color inputBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray60.withOpacity(0.3)
        : Colors.white; // White background for inputs in light mode
  }
  
  static Color inputBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray60
        : gray20; // Light border for light mode
  }
  
  static Color iconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray20
        : gray60; // Darker icons for light mode
  }
  
  static Color dividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray60.withOpacity(0.3)
        : gray20.withOpacity(0.5); // Light divider for light mode
  }
  
  static Color buttonBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray60.withOpacity(0.3)
        : Colors.white; // White button background for light mode
  }
  
  static Color overlayBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray.withOpacity(0.2)
        : Colors.black.withOpacity(0.05); // Light overlay for light mode
  }
  
  static Color chartBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff1A1A24).withOpacity(0.5)
        : Colors.white.withOpacity(0.8); // Light chart background
  }
  
  static Color borderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? gray40.withOpacity(0.3)
        : gray20.withOpacity(0.5); // Light border for light mode
  }
}
