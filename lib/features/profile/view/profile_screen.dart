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
    return Scaffold(body: const ProfileScreenLoader());
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
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFD56807).withOpacity(0.1),
                                border: Border.all(
                                  color: const Color(
                                    0xFFD56807,
                                  ).withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.cloud_off_rounded,
                                color: Color(0xFFD56807),
                                size: 56,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Unable to Load Profile',
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              style: GoogleFonts.mulish(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ProfileBloc>().add(
                                  LoadProfileData(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD56807),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.refresh, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Retry',
                                    style: GoogleFonts.mulish(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
