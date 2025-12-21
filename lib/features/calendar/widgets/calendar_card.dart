import 'package:excelapp2025/core/services/image_cache_service.dart';
import 'package:excelapp2025/features/calendar/data/models/calendar_event_model.dart';
import 'package:excelapp2025/features/event_detail/view/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarCard extends StatelessWidget {
  final CalendarEventModel event;
  const CalendarCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              eventId: event.id,
            ),
          ),
        );
      },
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF691701),
            Color(0xFF000000),
            Color(0xFF000000),
          ],
          stops: [0.0, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CachedImage(
            key: ValueKey('${event.id}-${event.icon}'),
            imageUrl: event.icon,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: GoogleFonts.mulish(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${event.time} | ${event.venue}',
                  style: GoogleFonts.mulish(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

}
