import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HtmlTextWidget extends StatelessWidget {
  final String htmlText;

  const HtmlTextWidget({super.key, required this.htmlText});

  @override
  Widget build(BuildContext context) {
    final text = htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('\r\n', '\n')
        .trim();
    return Text(
      text,
      style: GoogleFonts.mulish(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 2,
      ),
      textAlign: TextAlign.justify,
    );
  }
}

