import 'package:excelapp2025/features/calendar/bloc/calendar_bloc.dart';
import 'package:excelapp2025/features/calendar/bloc/calendar_event.dart';
import 'package:excelapp2025/features/calendar/bloc/calendar_state.dart';
import 'package:excelapp2025/features/calendar/data/repository/calendar_repo.dart';
import 'package:excelapp2025/features/calendar/widgets/calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarBloc(calendarRepo: CalendarRepo())
        ..add(LoadCalendarEventsEvent()),
      child: const CalendarScreenView(),
    );
  }
}

class CalendarScreenView extends StatelessWidget {
  const CalendarScreenView({super.key});

  void _selectDate(BuildContext context, DateTime date) {
    context.read<CalendarBloc>().add(SelectDateEvent(date: date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/discover_bg.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildDateSelector(context),
                const SizedBox(height: 30),
                Expanded(
                  child: _buildEventsList(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state is! CalendarLoaded) {
          return const SizedBox.shrink();
        }

        final availableDates = state.availableDates;
        if (availableDates.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: availableDates.map((date) {
              final isSelected = date.isSameDay(state.selectedDate);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () => _selectDate(context, date),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFFCF0A6)
                            : Colors.transparent,
                        width: isSelected ? 2.0 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        DateFormat('MMM dd').format(date),
                        style: GoogleFonts.mulish(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFCF0A6),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildEventsList(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state is CalendarLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF7B83F)),
            ),
          );
        }

        if (state is CalendarError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white70, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Failed to load events',
                  style: GoogleFonts.mulish(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: GoogleFonts.mulish(
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is CalendarLoaded) {
          if (state.events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_busy, color: Colors.white70, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'No events for this date',
                    style: GoogleFonts.mulish(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.events.length,
            itemBuilder: (context, index) {
              final event = state.events[index];
              return CalendarCard(
                key: ValueKey('${event.id}-${state.selectedDate.millisecondsSinceEpoch}'),
                event: event,
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

extension DateTimeExtension on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
