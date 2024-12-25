import 'package:flutter/material.dart';

Gradient primaryGradient() {
  return const LinearGradient(
    colors: [
      const Color(0xFF2C1B77),
      const Color(0xFF1D1C22),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
  );
}

Gradient landingGradient() {
  return const LinearGradient(
      colors: [const Color(0xFFFD95FF), const Color(0xFF2C1B77)],
      begin: FractionalOffset.topRight,
      end: FractionalOffset.bottomLeft,
      stops: [0.01, 1.0],
      transform: GradientRotation(-50));
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

Gradient drawerGradient() {
  return const LinearGradient(
    colors: [
      const Color(0xFF2C1B77),
      const Color(0xFFAD59AE),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomRight,
    stops: [0.4, 1.0],
  );
}