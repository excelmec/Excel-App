import 'package:excelapp2025/features/discover/bloc/discover_bloc.dart';
import 'package:excelapp2025/features/discover/bloc/discover_state.dart';
import 'package:excelapp2025/features/discover/data/models/event_model.dart';
import 'package:excelapp2025/features/event_detail/view/event_detail_screen.dart';
import 'package:excelapp2025/features/profile/view/create_acc_screen.dart';
import 'package:excelapp2025/features/profile/view/profile_signin.dart';
import 'package:excelapp2025/features/profile/view/show_profile.dart';
import 'package:excelapp2025/core/favorites/favorites_bloc.dart';
import 'package:excelapp2025/core/favorites/favorites_event.dart';
import 'package:excelapp2025/core/favorites/favorites_state.dart';
import 'package:excelapp2025/core/services/image_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../bloc/profile_bloc.dart';
import '../widgets/dialogue_sheet.dart';

class ProfileScreenMainView extends StatefulWidget {
  const ProfileScreenMainView({super.key});

  @override
  State<ProfileScreenMainView> createState() => _ProfileScreenMainViewState();
}

class _ProfileScreenMainViewState extends State<ProfileScreenMainView> {
  bool _isCreatingAccount = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          _isCreatingAccount =
              state.profileModel.institutionName == 'Unknown' ||
              state.profileModel.gender == 'Not Specified' ||
              state.profileModel.mobileNumber == 'Not Provided';
          return Stack(
            fit: StackFit.expand,
            children: [
              Image(
                image: Image.asset(
                  'assets/images/profile_background.png',
                ).image,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Container(color: Colors.black.withAlpha(100)),
              ),
              SafeArea(
                child: _isCreatingAccount
                    ? Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 30.0,
                          children: [
                            Text(
                              "Complete Your Profile",
                              style: GoogleFonts.mulish(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Looks like your profile is incomplete. To get the best experience, please complete your profile by providing the necessary details.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mulish(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 5.0,
                              children: [
                                ProfileGradientButton(
                                  icon: Icons.person_outline,
                                  title: "Complete Your Profile",
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<ProfileBloc>(),
                                          child: CreateAccScreen(
                                            mode: CreateAccMode.CREATE,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shape: CircleBorder(
                                      side: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (_) {
                                        return DialogueSheet(
                                          title: 'Confirm Logout',
                                          description:
                                              'Are you sure you want to logout?',
                                          primaryActionText: 'Yes',
                                          secondaryActionText: 'No',
                                          onPrimaryAction: () {
                                            context.read<ProfileBloc>().add(
                                              LogoutProfileRoutine(),
                                            );
                                            Navigator.of(context).pop();
                                          },
                                          onSecondaryAction: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.logout_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : BasicProfileDetails(
                        name: state.profileModel.name,
                        institutionName: state.profileModel.institutionName,
                        picture: state.profileModel.picture,
                        registeredEvents: state.profileModel.registeredEvents,
                      ),
              ),
            ],
          );
        } else if (state is ProfileError) {
          return Center(
            child: Column(
              children: [
                Text(state.message),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProfileBloc>().add(LoadProfileData());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<ProfileBloc>().add(LoadProfileData());
              },
              child: const Text('Load Profile'),
            ),
          );
        }
      },
    );
  }
}

class BasicProfileDetails extends StatefulWidget {
  final String name;
  final String institutionName;
  final String picture;
  final List<EventModel> registeredEvents;

  const BasicProfileDetails({
    super.key,
    required this.name,
    required this.institutionName,
    required this.picture,
    required this.registeredEvents,
  });

  @override
  State<BasicProfileDetails> createState() => _BasicProfileDetailsState();
}

class _BasicProfileDetailsState extends State<BasicProfileDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10.0,
      children: [
        //TODO : that black semi-transparent box behind the logout button & profile picture
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton.filledTonal(
              //TODO : logout functionality
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (_) {
                    return DialogueSheet(
                      title: 'Confirm Logout',
                      description: 'Are you sure you want to logout?',
                      primaryActionText: 'Yes',
                      secondaryActionText: 'No',
                      onPrimaryAction: () {
                        context.read<ProfileBloc>().add(LogoutProfileRoutine());
                        Navigator.of(context).pop();
                      },
                      onSecondaryAction: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
              iconSize: 16.0,
              padding: EdgeInsets.all(10.0),
              icon: const Icon(Icons.logout, color: Colors.black),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withAlpha(180),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<ProfileBloc>(),
                  child: ShowProfileView(),
                ),
              ),
            );
          },
          child: CircleAvatar(
            radius: 65,
            backgroundImage: Image.network(widget.picture).image,
          ),
        ),
        Text(
          widget.name,
          style: GoogleFonts.mulish(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          widget.institutionName,
          style: GoogleFonts.mulish(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.5,
          ),
        ),
        TabBar(
          controller: _tabController,
          //TODO : make indicator gradient like in design
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withAlpha(150),
          labelStyle: GoogleFonts.mulish(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          dividerColor: Colors.transparent,
          tabs: [
            Tab(text: 'Registered'),
            Tab(text: 'Favorites'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              //TODO : MAP Events from backend
              // Center(child: EventCard()),
              ListView.builder(
                itemCount: widget.registeredEvents.length,
                itemBuilder: (context, index) {
                  final event = widget.registeredEvents[index];
                  return EventCard(
                    title: event.name,
                    description: event.about,
                    date: DateFormat('MMM dd').format(event.datetime),
                    imageUrl: event.icon,
                    eventId: event.id,
                    isRegistered: true,
                  );
                },
              ),
              BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, favState) {
                  final favoriteIds = favState.favoriteIds;
                  
                  if (favoriteIds.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No Favorite Events',
                            style: GoogleFonts.mulish(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Start adding events to your favorites from Discover or Calendar screens',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mulish(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  // Filter registered events that are in favorites
                  final favoriteEvents = (context.read<DiscoverBloc>().state as DiscoverLoaded).events
                      .where((event) => favoriteIds.contains(event.id))
                      .toList();
                  
                  if (favoriteEvents.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No Favorite Events',
                            style: GoogleFonts.mulish(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Start adding events to your favorites from Discover or Calendar screens',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mulish(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: favoriteEvents.length,
                    itemBuilder: (context, index) {
                      final event = favoriteEvents[index];
                      return EventCard(
                        title: event.name,
                        description: event.about,
                        date: DateFormat('MMM dd').format(event.datetime),
                        imageUrl: event.icon,
                        eventId: event.id,
                        isRegistered: widget.registeredEvents
                            .any((e) => e.id == event.id),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.imageUrl,
    required this.eventId,
    required this.isRegistered
  });

  final String title;
  final String description;
  final String date;
  final String imageUrl;
  final int eventId;
  final bool isRegistered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      //TODO : adjust padding in bottom
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xAA691700),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CachedImage(
                    key: ValueKey('$eventId-$imageUrl'),
                    imageUrl: imageUrl,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(55.0),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.mulish(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.mulish(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: GoogleFonts.mulish(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      BlocBuilder<FavoritesBloc, FavoritesState>(
                        builder: (context, favState) {
                          final isFavorite = favState.isFavorite(eventId);
                          return IconButton(
                            // TODO : favorite functionality
                            // Also decide whether to use Icon from material icon or use custom icon for favorite
                            onPressed: () {
                              context.read<FavoritesBloc>().add(
                                context.read<FavoritesBloc>().state.isFavorite(eventId)
                                  ? RemoveFavoriteEvent(eventId)
                                  : AddFavoriteEvent(eventId),
                              );
                            },
                            icon: Icon(
                              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_outlined,
                              color: isFavorite ? const Color(0xFFD56807) : Colors.white,
                            ),
                          );
                        },
                      ),
                      TextButton(
                        // TODO : register functionality
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailScreen(
                                eventId: eventId,
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0x4D691700),
                        ),
                        child: Text(
                          isRegistered ? 'Registered' : 'Register',
                          style: GoogleFonts.mulish(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
