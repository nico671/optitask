import 'dart:ui';

class ColorPalette {
  final Color backgroundColor;
  final Color secondaryBackgroundColor;
  final Color cardBackgroundColor;

  final Color primaryTextColor;
  final Color secondaryTextColor;

  final Color accentColor;
  final Color disabledAccentColor;
  final Color completedColor;
  final Color pendingCompletionColor;
  final Color shadowColor;
  final Color calendarSelectedColor;
  final Color calendarDeselectedColor;
  ColorPalette(
      {required this.backgroundColor,
      required this.calendarDeselectedColor,
      required this.calendarSelectedColor,
      required this.shadowColor,
      required this.accentColor,
      required this.pendingCompletionColor,
      required this.completedColor,
      required this.disabledAccentColor,
      required this.secondaryBackgroundColor,
      required this.cardBackgroundColor,
      required this.primaryTextColor,
      required this.secondaryTextColor});
}
