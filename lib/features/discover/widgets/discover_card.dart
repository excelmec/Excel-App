import 'package:excelapp2025/core/services/image_cache_service.dart';
import 'package:excelapp2025/features/discover/data/models/event_model.dart';
import 'package:excelapp2025/features/event_detail/view/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DiscoverCard extends StatelessWidget {
  final EventModel event;
  const DiscoverCard({super.key, required this.event});

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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      margin: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFB23B02).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CachedImage(
                imageUrl: event.icon,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(12),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: GoogleFonts.mulish(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      event.about,
                      style: GoogleFonts.mulish(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600
                      ),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 6),
                  Text(
                    DateFormat("MMM dd").format(event.datetime.toLocal()),
                    style: GoogleFonts.mulish(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    color: const Color(0xFFD56807),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFF7B83F).withOpacity(0.4),
                    ),
                    child: Text(
                      'Register',
                      style: GoogleFonts.mulish(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
      ),
    );
  }

}