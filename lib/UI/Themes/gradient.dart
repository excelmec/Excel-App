import 'package:flutter/material.dart';

Gradient primaryGradient() {
  return const LinearGradient(
    colors: [
      Color(0xFF2C1B77),
      Color(0xFF000000),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
  );
}

Gradient primaryGradientHorizontal() {
  return const LinearGradient(
    colors: [
      Color(0xFF2C1B77),
      Color(0xFF000000),
    ],
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
    stops: [0.0, 1.0],
  );
}
