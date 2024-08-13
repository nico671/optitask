import 'package:flutter/material.dart';
import 'package:optitask/models/colorpalette.dart';

class ThemeProvider with ChangeNotifier {
  get theme {
    var brightness = WidgetsBinding.instance.window.platformBrightness;

    return brightness == Brightness.dark ? darkPalette : lightPalette;
  }
}

final ColorPalette darkPalette = ColorPalette(
    shadowColor: Colors.black.withOpacity(0.04),
    backgroundColor: const Color.fromARGB(255, 16, 28, 47),
    accentColor: const Color.fromARGB(255, 126, 135, 218),
    secondaryBackgroundColor: const Color.fromARGB(255, 24, 39, 65),
    primaryTextColor: const Color.fromARGB(255, 212, 223, 238),
    secondaryTextColor: const Color.fromARGB(255, 71, 86, 106),
    disabledAccentColor: const Color.fromARGB(255, 114, 114, 114),
    cardBackgroundColor: const Color.fromARGB(255, 16, 28, 47),
    completedColor: const Color.fromARGB(255, 18, 69, 110),
    pendingCompletionColor: const Color.fromARGB(255, 161, 41, 32),
    calendarDeselectedColor: const Color.fromARGB(255, 23, 40, 68),
    calendarSelectedColor: const Color.fromARGB(255, 36, 62, 105));
final ColorPalette lightPalette = ColorPalette(
    shadowColor: Colors.black.withOpacity(0.04),
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    completedColor: const Color.fromARGB(255, 30, 115, 184),
    accentColor: const Color.fromARGB(255, 126, 135, 218),
    secondaryBackgroundColor: const Color.fromARGB(255, 24, 39, 65),
    primaryTextColor: const Color.fromARGB(255, 45, 45, 45),
    secondaryTextColor: Colors.grey[600]!,
    disabledAccentColor: const Color.fromARGB(255, 114, 114, 114),
    cardBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    pendingCompletionColor: const Color.fromARGB(255, 161, 41, 32),
    calendarDeselectedColor: const Color.fromARGB(255, 239, 238, 241),
    calendarSelectedColor: const Color.fromARGB(255, 213, 213, 213));

class Styles {
  static ColorPalette themeData(bool isDarkTheme, BuildContext context) {
    return isDarkTheme ? darkPalette : lightPalette;
  }
}
