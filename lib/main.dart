import 'package:flutter/material.dart';
import 'package:excelapp2025/features/welcome/view/welcome_screen.dart';

import 'features/profile/view/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excel 2025',
      theme: ThemeData.dark(),
      initialRoute: '/profile',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
