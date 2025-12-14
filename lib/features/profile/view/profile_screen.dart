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
          child: ProfileScreenLoader(),
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
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileSignedOut || state is LoginStartedState) {
          return const ProfileSignInScreen();
        } else {
          return const ProfileScreenMainView();
        }
      },
    );
  }
}
