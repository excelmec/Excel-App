import 'package:flutter/material.dart';

Gradient primaryGradient() {
  return const LinearGradient(
    colors: [
      const Color(0xFF2C1B77),
      const Color(0xFF1D1C22),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.5, 1.0],
  );
}

Gradient landingGradient() {
  return const LinearGradient(
    colors: [
      const Color(0xFFFD95FF),
      const Color(0xFF2C1B77)
    ],
    begin: FractionalOffset.topRight,
    end: FractionalOffset.bottomLeft,
    stops: [0.01, 1.0],
    transform: GradientRotation(-50)
  );
}