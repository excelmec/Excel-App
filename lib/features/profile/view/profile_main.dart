import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/profile_bloc.dart';
import '../widgets/dialogue_sheet.dart';

class ProfileScreenMainView extends StatefulWidget {
  const ProfileScreenMainView({super.key});

  @override
  State<ProfileScreenMainView> createState() => _ProfileScreenMainViewState();
}

class _ProfileScreenMainViewState extends State<ProfileScreenMainView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image(
                image: Image.asset(
                  'assets/images/profile_background.png',
                ).image,
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: BasicProfileDetails(
                  name: state.profileModel.name,
                  institutionName: state.profileModel.institutionName,
                  picture: state.profileModel.picture,
                ),
              ),
            ],
          );
        } else if (state is ProfileError) {
          return Center(child: Text(state.message));
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

  const BasicProfileDetails({
    super.key,
    required this.name,
    required this.institutionName,
    required this.picture,
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
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/');
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
        CircleAvatar(
          radius: 65,
          backgroundImage: Image.network(widget.picture).image,
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
              Center(child: EventCard()),
              Center(child: Text('Favorite Events')),
            ],
          ),
        ),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      //TODO : adjust padding in bottom
      padding: const EdgeInsets.all(15.0),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(55.0),
                    child: Image.network(
                      'https://picsum.photos/100',
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event Title',
                          style: GoogleFonts.mulish(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Lorem ipsum dolor sit amet, conse ctetur adi piscing elit.',
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
                    "Dec 03",
                    style: GoogleFonts.mulish(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        // TODO : favorite functionality
                        // Also decide whether to use Icon from material icon or use custom icon for favorite
                        onPressed: () {},
                        icon: Icon(Icons.favorite_border_outlined),
                      ),
                      TextButton(
                        // TODO : register functionality
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0x4D691700),
                        ),
                        child: Text(
                          'Register',
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
