import 'package:flutter/material.dart';

class AppGradients {
  static const primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF836BFF), Color(0xFFBF5AF2)],
  );

  /// 3-colour gradient used on the greeting/hero card.
  static const greetingCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF836BFF), Color(0xFFBF5AF2), Color(0xFFFF6B8A)],
    stops: [0.0, 0.55, 1.0],
  );

  static const warm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B8A), Color(0xFFFF9A5C)],
  );

  static const teal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C9A7), Color(0xFF5FFBF1)],
  );

  static const cool = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667EEA), Color(0xFF64B5F6)],
  );
}
