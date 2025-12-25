import 'package:excelapp2025/features/event_detail/data/models/event_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'contact_card.dart';

class ContactTab extends StatelessWidget {
  final EventDetailModel event;

  const ContactTab({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final contacts = [event.eventHead1, event.eventHead2].whereType<EventHead>().toList();
    if (contacts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Text(
          'No contact information available',
          style: GoogleFonts.mulish(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: Column(
        children: contacts.map((contact) => ContactCard(contact: contact)).toList(),
      ),
    );
  }
}

