import 'package:excelapp2025/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
      child: Scaffold(
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {},
          child: const ProfileScreenView(),
        ),
      ),
    );
  }
}

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileData());
  }

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
              onPressed: () {},
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
              Center(child: Text('Registered Events')),
              Center(child: Text('Favorite Events')),
            ],
          ),
        ),
      ],
    );
  }
}
