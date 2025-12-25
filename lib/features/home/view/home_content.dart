import 'package:excelapp2025/features/home/cubit/index_cubit.dart';
import 'package:excelapp2025/features/home/widgets/contact_sheet.dart';
import 'package:excelapp2025/features/home/widgets/reach_us_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late PageController _pageController;
  int _selectedActionIndex = 0;
  DateTime? _targetDateTime;
  Duration? _timeRemaining;
  late Stream<Duration> _timerStream;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.5,
      initialPage: 1000 * 3 ~/ 2,
    );
    
    // Set target date to Jan 9, 2025
    _targetDateTime = DateTime(2026, 1, 9, 0, 0, 0);
    _updateTimeRemaining();
    
    // Create a stream that updates every second
    _timerStream = Stream.periodic(
      const Duration(seconds: 1),
      (_) => _calculateTimeRemaining(),
    );
  }

  Duration _calculateTimeRemaining() {
    final now = DateTime.now().toLocal();
    if (_targetDateTime == null || now.isAfter(_targetDateTime!)) {
      // Check if event is ongoing (between Jan 9 and Jan 11)
      final endDate = DateTime(2026, 1, 11, 23, 59, 59);
      if (now.isBefore(endDate)) {
        return Duration.zero; // Event is ongoing
      }
      return Duration.zero; // Event has ended
    }
    return _targetDateTime!.difference(now);
  }

  void _updateTimeRemaining() {
    setState(() {
      _timeRemaining = _calculateTimeRemaining();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IndexCubit, IndexState>(
      listener: (context, state) {
        setState(() {
          _selectedActionIndex = state.quickAccessIndex;
        });
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/welcome_background.png',
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildTopHeader(),
                    const SizedBox(height: 30),
                    _buildActionButtons(),
                    const SizedBox(height: 40),
                    _buildHighlightsCarousel(),
                    const SizedBox(height: 40),
                    _buildEventCountdown(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ShaderMask(
        shaderCallback: (bounds) => const RadialGradient(
          center: Alignment(0.33, -0.15),
          radius: 0.8,
          colors: [
            Color(0xFFFFE44A),
            Color(0xFFFDDD4F),
            Color(0xFFFFB946),
            Color(0xFFFFB02F),
            Color(0xFFFFDD3A),
            Color(0xFFF8B22A),
          ],
          stops: [0.0, 0.1816, 0.4087, 0.6538, 0.8706, 1.0],
        ).createShader(bounds),
        child: Text(
          'EXCEL 2025',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w300,
            fontSize: 27,
            height: 1.0,
            letterSpacing: 0.12 * 27,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCircleButton(
          index: 0,
          imagePath: 'assets/icons/excel.png',
          label: 'Excel',
          onTap: () {},
        ),
        _buildCircleButton(
          index: 1,
          imagePath: 'assets/icons/contacts.png',
          label: 'Contact Us',
          onTap: () {
            showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              useRootNavigator: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              context: context,
              builder: (context) => Wrap(children: <Widget>[contactUsModal(context)]),
              isDismissible: true,
            ).then((_) {
              context.read<IndexCubit>().updateIndex(0);
            });
          },
        ),
        _buildCircleButton(
          index: 2,
          imagePath: 'assets/icons/reachus.png',
          label: 'Reach Us',
          onTap: () {
            showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              useRootNavigator: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              context: context,
              builder: (context) => Wrap(children: <Widget>[reachUsModal(context)]),
              isDismissible: true,
            ).then((_) {
              context.read<IndexCubit>().updateIndex(0);
            });
          },
        ),
        _buildCircleButton(
          index: 3,
          imagePath: 'assets/icons/noti.png',
          label: 'Notifications',
          onTap: () {
            Navigator.pushNamed(context, '/notifications').then((_) {
              context.read<IndexCubit>().updateIndex(0);
            });
          },
          hasBadge: true,
        ),
      ],
    );
  }

  Widget _buildCircleButton({
    required int index,
    required String imagePath,
    required String label,
    required VoidCallback onTap,
    bool hasBadge = false,
  }) {
    final bool isSelected = _selectedActionIndex == index;

    return GestureDetector(
      onTap: () {
        context.read<IndexCubit>().updateIndex(index);
        onTap();
      },
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: isSelected
                      ? const Color(0xFF691701)
                      : Colors.white.withOpacity(0.15),
                ),
                child: Image.asset(
                  imagePath,
                  width: 28,
                  height: 28,
                  color: const Color(0xFFFCF0A6),
                ),
              ),
              if (hasBadge)
                Positioned(
                  top: 5,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.5,
                        colors: [
                          Color.fromRGBO(247, 184, 63, 0.7),
                          Color.fromRGBO(252, 240, 166, 0.7),
                        ],
                        stops: [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.mulish(
              fontWeight: FontWeight.w500,
              fontSize: 11,
              height: 1.4,
              letterSpacing: 0,
              color: const Color(0xFFE4EDEF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsCarousel() {
    final List<Map<String, String>> highlights = [
      {'title': 'Tug Of War', 'image': 'assets/images/tow.png'},
      {'title': 'Behind the Scenes', 'image': 'assets/images/bts.png'},
      {'title': 'Logo Launch', 'image': 'assets/images/lol.png'},
    ];

    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: null,
        itemBuilder: (context, index) {
          final actualIndex = index % highlights.length;
          final highlight = highlights[actualIndex];

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
              } else {
                value = (_pageController.initialPage - index).toDouble();
                value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
              }

              return Center(
                child: SizedBox(
                  height: Curves.easeInOut.transform(value) * 280,
                  width: Curves.easeInOut.transform(value) * 205,
                  child: child,
                ),
              );
            },
            child: _buildCarouselCard(
              title: highlight['title']!,
              imagePath: highlight['image']!,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarouselCard({
    required String title,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF691701).withOpacity(0.4),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HIGHLIGHTS',
                      style: GoogleFonts.mulish(
                        color: Colors.white70,
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: 0.15 * 8,
                      ),
                    ),
                    Text(
                      title[0].toUpperCase() + title.substring(1).toLowerCase(),
                      style: GoogleFonts.mulish(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildEventCountdown() {
    return StreamBuilder<Duration>(
      stream: _timerStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? _calculateTimeRemaining();
        final now = DateTime.now().toLocal();
        final endDate = DateTime(2026, 1, 11, 23, 59, 59);
        
        // Check if event has ended
        if (now.isAfter(endDate)) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(20),
            //   gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [
            //       Color(0xFF691701).withOpacity(0.8),
            //       Colors.black.withOpacity(0.9),
            //     ],
            //   ),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Color(0xFF691701).withOpacity(0.3),
            //       blurRadius: 20,
            //       spreadRadius: 2,
            //     ),
            //   ],
            // ),
            child: Center(
              child: Text(
                'EXCEL 2025 HAS CONCLUDED',
                style: GoogleFonts.nixieOne(
                  fontSize: 34,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFFFCF0A6),
                  letterSpacing: 3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        
        // Check if event is ongoing
        if (duration.inSeconds <= 0) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            padding: const EdgeInsets.all(20),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(20),
            //   gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [
            //       Color(0xFFF7B83F).withOpacity(0.9),
            //       Color(0xFF691701).withOpacity(0.9),
            //     ],
            //   ),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Color(0xFFF7B83F).withOpacity(0.4),
            //       blurRadius: 25,
            //       spreadRadius: 3,
            //     ),
            //   ],
            // ),
            child: Column(
              children: [
                Text(
                  'EXCEL 2025 IS LIVE!',
                  style: GoogleFonts.nixieOne(
                    fontSize: 36,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFFCF0A6),
                    letterSpacing: 3,
                  ),
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(height: 8),
                // Text(
                //   'EXCEL 2025 IN PROGRESS',
                //   style: GoogleFonts.mulish(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w600,
                //     color: Colors.white.withOpacity(0.9),
                //     letterSpacing: 1,
                //   ),
                // ),
              ],
            ),
          );
        }
        
        final days = duration.inDays;
        final hours = duration.inHours % 24;
        final minutes = duration.inMinutes % 60;
        final seconds = duration.inSeconds % 60;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF691701).withOpacity(0.6),
                Colors.black.withOpacity(0.8),
              ],
            ),
            border: Border.all(
              color: Color(0xFFF7B83F).withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF691701).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Color(0xFFFCF0A6),
                    Color(0xFFF7B83F),
                  ],
                ).createShader(bounds),
                child: Text(
                  'EXCEL 2025 IN',
                  style: GoogleFonts.aldrich(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  _buildTimeUnit(days.toString().padLeft(2, '0'), 'DAYS'),
                  _buildTimeDivider(),
                  _buildTimeUnit(hours.toString().padLeft(2, '0'), 'HOURS'),
                  _buildTimeDivider(),
                  _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'MINS'),
                  _buildTimeDivider(),
                  _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'SECS'),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'JAN 9 - JAN 11, 2026',
                      style: GoogleFonts.mulish(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFCF0A6),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return SizedBox(
      width: 65,
      child: Column(
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0xFFF7B83F).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                value,
                style: GoogleFonts.aldrich(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFCF0A6),
                  height: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.mulish(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.7),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDivider() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        ':',
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFFF7B83F).withOpacity(0.6),
          height: 1.0,
        ),
      ),
    );
  }
}
