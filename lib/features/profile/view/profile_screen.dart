import 'package:excelapp2025/features/profile/bloc/profile_bloc.dart';
import 'package:excelapp2025/features/profile/view/profile_signin.dart';
import 'package:excelapp2025/features/profile/view/profile_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: Scaffold(
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {},
          child: const ProfileScreenLoader(),
        ),
      ),
    );
  }
}

class ProfileScreenLoader extends StatefulWidget {
  const ProfileScreenLoader({super.key});

  @override
  State<ProfileScreenLoader> createState() => _ProfileScreenLoaderState();
}

class _ProfileScreenLoaderState extends State<ProfileScreenLoader> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSignedIn) {
          context.read<ProfileBloc>().add(LoadProfileData());
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return const ProfileScreenMainView();
        } else if (state is ProfileSignedOut) {
          return const ProfileSignInScreen();
        } else {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/profile_background.png',
                fit: BoxFit.cover,
              ),
              (state is ProfileError)
                  ? const Center(
                      child: ElevatedButton(
                        onPressed: null,
                        child: Text('Load Profile'),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
            ],
          );
        }
      },
    );
  }
}
