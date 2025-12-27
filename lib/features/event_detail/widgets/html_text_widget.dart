import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HtmlTextWidget extends StatelessWidget {
  final String htmlText;

  const HtmlTextWidget({super.key, required this.htmlText});

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.mulish(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w500,
      height: 2,
    );

    final boldStyle = GoogleFonts.mulish(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w700,
      height: 2,
    );

    String text = htmlText;

    // First decode HTML entities
    text = text
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    // Convert <br/> tags to newlines
    text = text.replaceAll(RegExp(r'<br\s*/?\s*>', caseSensitive: false), '\n');
    text = text.replaceAll('<br/>', '\n');
    text = text.replaceAll('<br>', '\n');
    text = text.replaceAll('<BR/>', '\n');
    text = text.replaceAll('<BR>', '\n');

    // Convert closing tags for block elements to newlines
    text = text.replaceAll(RegExp(r'</(p|div|li|h[1-6])>', caseSensitive: false), '\n');

    // Parse <strong> tags and build TextSpan list
    final spans = <TextSpan>[];
    final regex = RegExp(r'<strong>(.*?)</strong>', caseSensitive: false);
    int lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      // Add text before the match
      if (match.start > lastIndex) {
        final beforeText = text.substring(lastIndex, match.start);
        // Remove any remaining HTML tags from before text
        final cleanBefore = beforeText.replaceAll(RegExp(r'<[^>]*>'), '');
        if (cleanBefore.isNotEmpty) {
          spans.add(TextSpan(text: cleanBefore, style: baseStyle));
        }
      }

      // Add bold text
      final boldText = match.group(1) ?? '';
      final cleanBold = boldText.replaceAll(RegExp(r'<[^>]*>'), '');
      if (cleanBold.isNotEmpty) {
        spans.add(TextSpan(text: cleanBold, style: boldStyle));
      }

      lastIndex = match.end;
    }

    // Add remaining text after last match
    if (lastIndex < text.length) {
      final afterText = text.substring(lastIndex);
      final cleanAfter = afterText.replaceAll(RegExp(r'<[^>]*>'), '');
      if (cleanAfter.isNotEmpty) {
        spans.add(TextSpan(text: cleanAfter, style: baseStyle));
      }
    }

    // If no <strong> tags found, use simple text
    if (spans.isEmpty) {
      final cleanText = text.replaceAll(RegExp(r'<[^>]*>'), '');
      return Text(
        cleanText.trim(),
        style: baseStyle,
        textAlign: TextAlign.justify,
      );
    }

    // Normalize line breaks in spans
    for (var i = 0; i < spans.length; i++) {
      if (spans[i].text != null) {
        var normalized = spans[i].text!
            .replaceAll('\r\n', '\n')
            .replaceAll('\r', '\n');
        normalized = normalized.replaceAll(RegExp(r'\n{3,}'), '\n\n');
        spans[i] = TextSpan(text: normalized, style: spans[i].style);
      }
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.justify,
    );
  }
}
