import 'package:excelapp2025/features/home/cubit/index_cubit.dart';
import 'package:excelapp2025/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:excelapp2025/features/welcome/view/welcome_screen.dart';
import 'package:excelapp2025/features/home/view/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/profile/view/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => IndexCubit()),
      ],
      child: MaterialApp(
        title: 'Excel 2025',
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
