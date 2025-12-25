import 'package:excelapp2025/core/services/image_cache_service.dart';
import 'package:excelapp2025/core/favorites/favorites_bloc.dart';
import 'package:excelapp2025/core/favorites/favorites_event.dart';
import 'package:excelapp2025/core/favorites/favorites_state.dart';
import 'package:excelapp2025/features/event_detail/bloc/event_detail_bloc.dart';
import 'package:excelapp2025/features/event_detail/bloc/event_detail_event.dart';
import 'package:excelapp2025/features/event_detail/bloc/event_detail_state.dart';
import 'package:excelapp2025/features/event_detail/data/models/event_detail_model.dart';
import 'package:excelapp2025/features/event_detail/data/repository/event_detail_repo.dart';
import 'package:excelapp2025/features/event_detail/widgets/event_details_grid.dart';
import 'package:excelapp2025/features/event_detail/widgets/footer_tabs.dart';
import 'package:excelapp2025/features/event_detail/widgets/about_tab.dart';
import 'package:excelapp2025/features/event_detail/widgets/format_tab.dart';
import 'package:excelapp2025/features/event_detail/widgets/rules_tab.dart';
import 'package:excelapp2025/features/event_detail/widgets/contact_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatelessWidget {
  final int eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventDetailBloc(
        eventDetailRepo: EventDetailRepo(),
      )..add(LoadEventDetailEvent(eventId)),
      child: const EventDetailScreenView(),
    );
  }
}

class EventDetailScreenView extends StatefulWidget {
  const EventDetailScreenView({super.key});

  @override
  State<EventDetailScreenView> createState() => _EventDetailScreenViewState();
}

class _EventDetailScreenViewState extends State<EventDetailScreenView> {
  int _selectedTabIndex = 0;

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
            child: BlocBuilder<EventDetailBloc, EventDetailState>(
              builder: (context, state) {
                if (state is EventDetailLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF7B83F)),
                    ),
                  );
                }

                if (state is EventDetailError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white70, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load event details',
                          style: GoogleFonts.mulish(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: GoogleFonts.mulish(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (state is EventDetailLoaded) {
                  return Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildEventIcon(state.event),
                              const SizedBox(height: 16),
                              _buildEventName(state.event),
                              const SizedBox(height: 32),
                              EventDetailsGrid(event: state.event),
                              const SizedBox(height: 24),
                              _buildRegisterButton(state.event),
                              const SizedBox(height: 24),
                              _buildTabContent(state.event),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                      FooterTabs(
                        selectedIndex: _selectedTabIndex,
                        onTabSelected: (index) => setState(() => _selectedTabIndex = index),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader() {
    return BlocBuilder<EventDetailBloc, EventDetailState>(
      builder: (context, state) {
        final eventId = (state is EventDetailLoaded) ? state.event.id : 0;
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, favState) {
                  final isFavorite = favState.isFavorite(eventId);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite_rounded : Icons.favorite_border,
                      color: isFavorite ? const Color(0xFFD56807) : Colors.white,
                      size: 28,
                    ),
                    onPressed: eventId > 0 ? () {
                      context.read<FavoritesBloc>().add(ToggleFavoriteEvent(eventId));
                    } : null,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventIcon(EventDetailModel event) {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: event.icon.isNotEmpty
            ? CachedImage(
                imageUrl: event.icon,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(60),
              )
            : Container(
                color: Colors.grey[800],
                child: const Icon(Icons.event, color: Colors.white, size: 60),
              ),
      ),
    );
  }

  Widget _buildEventName(EventDetailModel event) {
    return Text(
      event.name,
      style: GoogleFonts.mulish(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRegisterButton(EventDetailModel event) {
    final link = event.registrationLink?.trim();
    if (link == null || link.isEmpty || link == 'string' || link == 'null') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 184,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          border: Border.all(color: const Color(0xFF691701), width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              try {
                final uri = Uri.parse(link);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid registration link'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Text(
                    'Register',
                    style: GoogleFonts.mulish(
                      color: const Color(0xFF691701),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: Icon(Icons.arrow_forward, color: Color(0xFF691701), size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(EventDetailModel event) {
    switch (_selectedTabIndex) {
      case 0:
        return AboutTab(event: event);
      case 1:
        return FormatTab(event: event);
      case 2:
        return RulesTab(event: event);
      case 3:
        return ContactTab(event: event);
      default:
        return AboutTab(event: event);
    }
  }
}
