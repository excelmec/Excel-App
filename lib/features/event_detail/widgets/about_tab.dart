import 'package:excelapp2025/features/event_detail/data/models/event_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutTab extends StatelessWidget {
  final EventDetailModel event;

  const AboutTab({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Text(
        event.about,
        style: GoogleFonts.mulish(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 2,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
