import 'package:excelapp2025/features/event_detail/data/models/event_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'html_text_widget.dart';

class FormatTab extends StatelessWidget {
  final EventDetailModel event;

  const FormatTab({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final format = event.format.trim().toUpperCase();
    if (format.isEmpty || format == 'NIL' || format == 'NULL') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description_outlined,
              color: Colors.white70,
              size: 36,
            ),
            const SizedBox(height: 16),
            Text(
              'No format applicable',
              style: GoogleFonts.mulish(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: HtmlTextWidget(htmlText: event.format),
    );
  }
}
