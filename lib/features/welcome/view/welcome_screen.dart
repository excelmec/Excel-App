import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:excelapp2025/features/welcome/bloc/welcome_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WelcomeBloc(),
      child: Scaffold(
        body: BlocListener<WelcomeBloc, WelcomeState>(
          listener: (context, state) {
            if (state is WelcomeNavigateToHomeActionState) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: WelcomeScreenView(),
        ),
      ),
    );
  }
}

class WelcomeScreenView extends StatelessWidget {
  const WelcomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/welcome_background.png', fit: BoxFit.cover),

        Center(
          child: Opacity(
            opacity: 0.3,

            child: Image.asset(
              'assets/images/welcome_bg_logo.png',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 60.0,
              vertical: 37.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 1),
                Transform.translate(
                  offset: const Offset(
                    0,
                    -20,
                  ), 
                  child: Center(
                    child: Text(
                      'Welcome to\nExcel 2025',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.normal,
                        height: 1.1,
                        letterSpacing: 0.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Excel is the annual techno-managerial fest of Govt. Model Enginnering College. It’s the Nation’s second and South India’s first ever fest of it’s kind!",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.mulish(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: const Color(0xFFE7F1F3),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<WelcomeBloc>().add(
                        GetStartedButtonClickedEvent(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.transparent, 
                      shadowColor:
                          Colors.transparent, 
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(
                              (0.8 * 255).round(),
                              0xFC,
                              0xF0,
                              0xA6,
                            ), 
                            Color.fromARGB(
                              (0.8 * 255).round(),
                              0xF7,
                              0xB8,
                              0x3F,
                            ), 
                          ],
                        ),

                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: SizedBox(
                        width: 221,
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Get started',
                              style: GoogleFonts.mulish(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white, 
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
