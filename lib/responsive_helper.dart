import 'package:flutter/material.dart';

class ResponsiveHelper {
  static double dynamicWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  static double dynamicHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

  static double dynamicText(BuildContext context, double size) {
    double baseWidth = 375.0; // standard iPhone width for scaling
    return (MediaQuery.of(context).size.width / baseWidth) * size * 3;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }
}
