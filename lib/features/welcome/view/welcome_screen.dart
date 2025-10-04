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
        Image.asset(
          'assets/images/welcome_background.png',
          fit: BoxFit.cover,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),
                Text(
                  'Welcome to\nExcel 2025',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w800, 
                    fontStyle: FontStyle.normal,
                    height: 1.0,
                    letterSpacing: 0.0, 
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Excel is the annual techno-managerial fest of Govt. Model Enginnering College. It’s the Nation’s second and South India’s first ever fest of it’s kind!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mulish(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: const Color(0xFFE7F1F3),
                    height: 1.5, 
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    context.read<WelcomeBloc>().add(GetStartedButtonClickedEvent());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFDD835), Color(0xFFDAA520)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Get started',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.black),
                        ],
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