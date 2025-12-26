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
import 'package:excelapp2025/features/profile/view/profile_screen.dart';
import 'package:excelapp2025/features/profile/view/create_acc_screen.dart';
import 'package:excelapp2025/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatelessWidget {
  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EventDetailBloc(eventDetailRepo: EventDetailRepo())
            ..add(LoadEventDetailEvent(eventId)),
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
          Image.asset('assets/images/discover_bg.png', fit: BoxFit.cover),
          SafeArea(
            child: BlocListener<EventDetailBloc, EventDetailState>(
              listener: (context, state) {
                if (state is RegistrationSuccess) {
                  // Open external registration link
                  _launchRegistrationLink(context, state.registrationLink);
                } else if (state is RegistrationRequiresLogin) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please login to continue'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                } else if (state is RegistrationRequiresProfile) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please complete your profile to register'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  final bloc = ProfileBloc();
                  bloc.add(LoadProfileData());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateAccScreen(mode: CreateAccMode.UPDATE),
                    ),
                  );
                } else if (state is RegistrationFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Registration failed: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: BlocBuilder<EventDetailBloc, EventDetailState>(
                builder: (context, state) {
                  if (state is EventDetailLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFF7B83F),
                        ),
                      ),
                    );
                  }

                  if (state is EventDetailError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white70,
                            size: 48,
                          ),
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

                  // Get event from any state that contains it
                  final event = _getEventFromState(state);
                  if (event == null) {
                    return const SizedBox.shrink();
                  }

                  final isLoading = state is RegistrationLoading;

                  return Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildEventIcon(event),
                              const SizedBox(height: 16),
                              _buildEventName(event),
                              const SizedBox(height: 32),
                              EventDetailsGrid(event: event),
                              const SizedBox(height: 24),
                              _buildRegisterButton(event, isLoading),
                              _buildRegistrationStatus(event),
                              const SizedBox(height: 24),
                              _buildTabContent(event),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                      FooterTabs(
                        selectedIndex: _selectedTabIndex,
                        onTabSelected: (index) =>
                            setState(() => _selectedTabIndex = index),
                      ),
                    ],
                  );
                },
              ),
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
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border,
                      color: isFavorite
                          ? const Color(0xFFD56807)
                          : Colors.white,
                      size: 28,
                    ),
                    onPressed: eventId > 0
                        ? () {
                            context.read<FavoritesBloc>().add(
                              ToggleFavoriteEvent(eventId),
                            );
                          }
                        : null,
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

  Widget _buildRegisterButton(EventDetailModel event, bool isLoading) {
    final link = event.registrationLink?.trim();

    // Hide button if registration link is empty or null
    if (link == null || link.isEmpty || link == 'string' || link == 'null') {
      return const SizedBox.shrink();
    }

    // Hide button if registration is not needed
    if (!event.needRegistration) {
      return const SizedBox.shrink();
    }

    // Hide button if registration is closed
    if (event.registrationOpen == false) {
      return const SizedBox.shrink();
    }

    // Hide button if registration end date is in the past
    if (event.registrationEndDate != null) {
      final now = DateTime.now();
      if (event.registrationEndDate!.isBefore(now)) {
        return const SizedBox.shrink();
      }
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
            onTap: isLoading
                ? null
                : () {
                    context.read<EventDetailBloc>().add(
                      RegisterForEventEvent(
                        eventId: event.id,
                        registrationLink: link,
                      ),
                    );
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF691701),
                      ),
                      strokeWidth: 2,
                    ),
                  )
                else ...[
                  Text(
                    'Register',
                    style: GoogleFonts.mulish(
                      color: const Color(0xFF691701),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF691701),
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationStatus(EventDetailModel event) {
    final link = event.registrationLink?.trim();
    final hasValidLink =
        link != null && link.isNotEmpty && link != 'string' && link != 'null';

    // Show "Registration closes on [date]" below button if button is visible and date is available
    final buttonVisible =
        hasValidLink &&
        event.needRegistration &&
        event.registrationOpen == true &&
        (event.registrationEndDate == null ||
            event.registrationEndDate!.isAfter(DateTime.now()));

    if (buttonVisible && event.registrationEndDate != null) {
      final formattedDate = _formatDate(event.registrationEndDate!);
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          'Registration closes on $formattedDate',
          style: GoogleFonts.mulish(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  EventDetailModel? _getEventFromState(EventDetailState state) {
    if (state is EventDetailLoaded) return state.event;
    if (state is RegistrationLoading) return state.event;
    if (state is RegistrationSuccess) return state.event;
    if (state is RegistrationRequiresLogin) return state.event;
    if (state is RegistrationRequiresProfile) return state.event;
    if (state is RegistrationFailed) return state.event;
    return null;
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

  Future<void> _launchRegistrationLink(
    BuildContext context,
    String link,
  ) async {
    try {
      final uri = Uri.tryParse(link);
      if (uri == null) {
        throw 'Invalid URL format';
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('Invalid URL')
                  ? 'Invalid registration link'
                  : 'Unable to open registration link',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
