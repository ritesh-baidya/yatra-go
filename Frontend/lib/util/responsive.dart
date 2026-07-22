import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  Responsive(this.context);

  Size get size {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    
    // Clamp layout size to mobile simulation bounds on desktop
    if (width > 480) {
      final clampedHeight = height > 940 ? 900 : height - 40;
      return Size(360, clampedHeight.toDouble());
    }
    return Size(width, height);
  }

  double widthPct(double pct) => size.width * pct;
  double heightPct(double pct) => size.height * pct;
  bool get isMobile => MediaQuery.of(context).size.width <= 480;
  bool get isTablet => MediaQuery.of(context).size.width > 480 && MediaQuery.of(context).size.width <= 1024;
  bool get isDesktop => MediaQuery.of(context).size.width > 1024;
}
