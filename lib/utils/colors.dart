import 'package:flutter/material.dart';

class CustomColors {
  static Color colorPercent(double perc) {
    if (perc < 0.3) return Colors.redAccent;
    if (perc < 0.6) return Colors.amberAccent;

    return Colors.green;
  }

  static const Color tabSelectionColor = Color.fromARGB(255, 141, 155, 252);
  static const Color titleColor = Color.fromARGB(255, 244, 81, 30);
  static const Color accentColor = Colors.amber;
}
