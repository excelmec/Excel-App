import 'package:excelapp2025/features/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowProfileView extends StatefulWidget {
  const ShowProfileView({super.key});

  @override
  State<ShowProfileView> createState() => _ShowProfileViewState();
}

class _ShowProfileViewState extends State<ShowProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image(
                  image: Image.asset(
                    'assets/images/profile_background.png',
                  ).image,
                  fit: BoxFit.cover,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.directional(
                          topStart: Radius.circular(0),
                          topEnd: Radius.circular(0),
                          bottomStart: Radius.circular(1000),
                          bottomEnd: Radius.circular(1000),
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image(
                          //   image: Image.asset("assets/images/m.png").image,
                          //   fit: BoxFit.cover,
                          // ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppBar(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                              CircleAvatar(
                                radius: 65,
                                backgroundImage: Image.network(
                                  state.profileModel.picture,
                                ).image,
                              ),
                              Text(
                                state.profileModel.name,
                                style: GoogleFonts.mulish(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: 20.0,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            spacing: 20.0,
                            children: [
                              Expanded(
                                child: DetailChips(
                                  icon: Icons.person_outline,
                                  title: 'Gender',
                                  detail: state.profileModel.gender,
                                ),
                              ),
                              Expanded(
                                child: DetailChips(
                                  icon: Icons.phone_in_talk,
                                  title: 'Phone',
                                  detail: state.profileModel.mobileNumber,
                                ),
                              ),
                            ],
                          ),
                          DetailChips(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            detail: state.profileModel.email,
                          ),
                          DetailChips(
                            icon: Icons.pin_drop_outlined,
                            title: 'Institution',
                            detail: state.profileModel.institutionName,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class DetailChips extends StatelessWidget {
  const DetailChips({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFCF0A6), Color(0xFFF7B83F)],
          begin: AlignmentGeometry.centerLeft,
          end: AlignmentGeometry.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 28),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.mulish(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  detail,
                  style: GoogleFonts.mulish(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
