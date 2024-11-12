import 'package:flutter/material.dart';

Gradient primaryGradient() {
  return const LinearGradient(
    colors: [
      const Color(0xFF2C1B77),
      const Color(0xFF000000),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.5, 1.0],
  );
}
