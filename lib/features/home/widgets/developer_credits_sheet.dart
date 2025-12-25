import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeveloperCreditsSheet extends StatelessWidget {
  const DeveloperCreditsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image at full opacity
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            child: Image.asset(
              'assets/images/contact_card_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay on top
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFCF0A6).withOpacity(0.5), // Lighter golden-brown
                  Color(0xFF704F2D).withOpacity(0.7), // Darker brown
                  Color(0xFF541E03).withOpacity(0.9), // Darkest brown
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Content on top
          Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Image.asset(
            "assets/icons/divider.png",
            width: 340,
          ),
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Core Developers & Designers',
                style: GoogleFonts.mulish(
                  color: Colors.white,
                  fontWeight: FontWeight.w900, // ExtraBlack (1000)
                  fontSize: 22.0,
                  height: 1.0, // line-height: 100%
                  letterSpacing: 0.0, // letter-spacing: 0%
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              itemCount: _developers.length,
              itemBuilder: (context, index) {
                final developer = _developers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        developer['name']!,
                        style: GoogleFonts.mulish(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        developer['email']!,
                        style: GoogleFonts.mulish(
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 48),
        ],
          ),
        ],
      ),
    );
  }

  static final List<Map<String, String>> _developers = [
    {'name': 'Pranav M', 'email': 'pranavm265@gmail.com'},
    {'name': 'Nived R S', 'email': 'nivedrsalini@gmail.com'},
    {'name': 'Ashwin Sajeev', 'email': 'ashmercesletifercoc@gmail.com'},
    {'name': 'Aaron Kurian Abraham', 'email': 'aaronkuriabraham@gmail.com'},
    {'name': 'Joe Cyriac', 'email': 'joecyriac20@gmail.com'},
    {'name': 'Anet Davis', 'email': 'anetndavis@gmail.com'},
    {'name': 'Isha Paulin I B', 'email': 'ishapaulinib246@gmail.com'},
    {'name': 'Niranjana A', 'email': 'niranjana6002@gmail.com'},
    {'name': 'Anjana', 'email': 'anjanaanoop60@gmail.com'},
  ];
}