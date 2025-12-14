import 'package:excelapp2025/features/home/cubit/index_cubit.dart';
import 'package:excelapp2025/features/home/widgets/contact_sheet.dart';
import 'package:excelapp2025/features/home/widgets/reach_us_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _selectedActionIndex = 0;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.5,
      initialPage: 1000 * 3 ~/ 2,
    );
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
          _selectedNavIndex = state.navBarIndex;
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
                  ],
                ),
              ),
            ),
            _buildCustomBottomNavBar(),
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
              shape: RoundedRectangleBorder(
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
              shape: RoundedRectangleBorder(
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
        // setState(() {
        //   _selectedActionIndex = index;
        // });
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

  Widget _buildCustomBottomNavBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 80,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    index: 0,
                    iconPath: 'assets/icons/home.png',
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 1,
                    iconPath: 'assets/icons/discover.png',
                  ),
                ),
                const SizedBox(width: 88),
                Expanded(
                  child: _buildNavItem(
                    index: 2,
                    iconPath: 'assets/icons/calendar.png',
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 3,
                    iconPath: 'assets/icons/user.png',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(247, 184, 63, 1.0),
                    Color.fromARGB(255, 235, 215, 148),
                    Colors.black,
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/navlogo.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required int index, required String iconPath}) {
    final bool isSelected = _selectedNavIndex == index;

    final String selectedIconPath = iconPath.replaceFirst(
      '.png',
      '_selected.png',
    );

    final gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color.fromRGBO(247, 184, 63, 0.66), Color(0xFFFCF0A6)],
    );

    return IconButton(
      onPressed: () {
        context.read<IndexCubit>().updateNavIndex(index);
        setState(() {
          // _selectedNavIndex = index;
          if (index == 3) {
            Navigator.pushNamed(context, '/profile').then((_) {
              context.read<IndexCubit>().updateNavIndex(0);
            });
          }
        });
      },
      icon: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 44,
          maxWidth: 65,
          minHeight: 44,
          maxHeight: 47,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: isSelected
                ? SizedBox(
                    key: ValueKey('selected_$index'),
                    width: 78,
                    height: 44,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF691701),
                            Color.fromRGBO(105, 23, 1, 0.5),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          selectedIconPath,
                          width: 19,
                          height: 19,
                        ),
                      ),
                    ),
                  )
                : ShaderMask(
                    key: ValueKey('unselected_$index'),
                    shaderCallback: (bounds) => gradient.createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Image.asset(
                      iconPath,
                      width: 19,
                      height: 19,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
