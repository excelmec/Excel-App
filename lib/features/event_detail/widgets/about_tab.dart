import 'package:excelapp2025/features/event_detail/data/models/event_detail_model.dart';
import 'package:flutter/material.dart';
import 'html_text_widget.dart';

class AboutTab extends StatelessWidget {
  final EventDetailModel event;

  const AboutTab({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: HtmlTextWidget(htmlText: event.about),
    );
  }
}
