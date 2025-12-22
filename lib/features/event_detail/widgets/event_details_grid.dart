import 'package:excelapp2025/features/event_detail/data/models/event_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event_detail_card.dart';

class EventDetailsGrid extends StatelessWidget {
  final EventDetailModel event;

  const EventDetailsGrid({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      EventDetailCard(
        iconPath: 'assets/icons/calendar.svg',
        label: 'Date',
        value: DateFormat('MMM dd').format(event.datetime.toLocal()),
      ),
      EventDetailCard(
        iconPath: 'assets/icons/time.svg',
        label: 'Time',
        value: DateFormat('h:mm a').format(event.datetime.toLocal()).toLowerCase(),
      ),
      if (event.venue.isNotEmpty)
        EventDetailCard(
          iconPath: 'assets/icons/location.svg',
          label: 'Venue',
          value: event.venue,
        ),
      if (event.entryFee != null)
        EventDetailCard(
          iconPath: 'assets/icons/fees.png',
          label: 'Entry Fees',
          value: '₹${event.entryFee}',
        ),
      if (event.prizeMoney != null)
        EventDetailCard(
          iconPath: 'assets/icons/fees.png',
          label: 'Prize Pool',
          value: '₹${event.prizeMoney}',
        ),
      if (event.teamSize != null)
        EventDetailCard(
          iconPath: 'assets/icons/user.svg',
          label: 'Team Size',
          value: '${event.teamSize}',
        ),
    ];

    if (cards.isEmpty) return const SizedBox.shrink();

    final isOdd = cards.length % 2 == 1;
    final pairs = cards.length - (isOdd ? 1 : 0);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 54.0 : 48.0;
    final cardSpacing = screenWidth > 600 ? 40.0 : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          for (int i = 0; i < pairs; i += 2)
            Padding(
              padding: EdgeInsets.only(bottom: i + 2 < pairs ? 28 : (isOdd ? 28 : 0)),
              child: Row(
                children: [
                  Expanded(child: cards[i]),
                  SizedBox(width: cardSpacing),
                  Expanded(child: cards[i + 1]),
                ],
              ),
            ),
          if (isOdd)
            LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final cardWidth = (availableWidth - cardSpacing) / 2;
                return Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      width: cardWidth.clamp(100.0, double.infinity),
                      child: cards.last,
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

