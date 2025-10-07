import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.6,
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
    return Scaffold(
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
        _buildCircleButton(icon: Icons.close, label: 'Excel', onTap: () {}),
        _buildCircleButton(icon: Icons.phone, label: 'Contact Us', onTap: () {}),
        _buildCircleButton(icon: Icons.location_on, label: 'Reach Us', onTap: () {}),
        _buildCircleButton(icon: Icons.notifications, label: 'Notifications', onTap: () {}, hasBadge: true),
      ],
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool hasBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.25),
                  border: Border.all(color: Colors.red.withOpacity(0.5), width: 1),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              if (hasBadge)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
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
              }
              
              return Center(
                child: SizedBox(
                  height: Curves.easeInOut.transform(value) * 280,
                  width: Curves.easeInOut.transform(value) * 200,
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

  Widget _buildCarouselCard({required String title, required String imagePath}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
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
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('HIGHLIGHTS', style: TextStyle(color: Colors.white70, fontSize: 10)),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
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
            height: 65,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.home, isSelected: true),
                _buildNavItem(icon: Icons.explore_outlined),
                const SizedBox(width: 50),
                _buildNavItem(icon: Icons.calendar_today_outlined),
                _buildNavItem(icon: Icons.person_outline),
              ],
            ),
          ),
          Positioned(
            bottom: 35,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Colors.amber, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: const Icon(Icons.flash_on, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, bool isSelected = false}) {
    return isSelected
        ? Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(0.8),
            ),
            child: Icon(icon, color: Colors.white),
          )
        : IconButton(
            icon: Icon(icon, color: Colors.white70),
            onPressed: () {},
          );
  }
}