import 'package:excelapp2025/features/discover/bloc/discover_bloc.dart';
import 'package:excelapp2025/features/discover/data/repository/event_repo.dart';
import 'package:excelapp2025/features/home/cubit/index_cubit.dart';
import 'package:excelapp2025/features/home/view/notifications/views/notifications_screen.dart';
import 'package:excelapp2025/features/navigation/main_navigation_screen.dart';
import 'package:excelapp2025/features/profile/bloc/profile_bloc.dart';
import 'package:excelapp2025/features/splash/splash_screen.dart';
import 'package:excelapp2025/firebase_options.dart';
import 'package:excelapp2025/core/favorites/favorites_bloc.dart';
import 'package:excelapp2025/core/favorites/favorites_event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excelapp2025/features/welcome/view/welcome_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
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
        BlocProvider(create: (_) => DiscoverBloc(eventRepo: EventRepo())),
        BlocProvider(
          create: (_) => FavoritesBloc()..add(LoadFavoritesEvent()),
        ),
        BlocProvider(create: (_) => ProfileBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Excel 2025',
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/home': (context) => const MainNavigationScreen(),
          '/notifications': (context) => const NotificationsScreen(),
        },
      ),
    );
  }
}
