import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:excelapp2025/features/home/widgets/developer_credits_sheet.dart';

class AboutExcelPopUp extends StatefulWidget {
  const AboutExcelPopUp({super.key});

  @override
  State<AboutExcelPopUp> createState() => _AboutExcelPopUpState();
}

class _AboutExcelPopUpState extends State<AboutExcelPopUp> with TickerProviderStateMixin {
  int _currentLogoIndex = 11; // Start at 2014 (last in reversed list)
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  bool _isAnimating = true;
  
  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    _rotateAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeOutCubic),
    );
    
    // Start the intro animation sequence
    _startIntroSequence();
  }
  
  void _startIntroSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Animation timings that accelerate then decelerate
    final delays = [
      800,  // 2014
      750,  // 2015
      700,  // 2016
      600,  // 2017
      500,  // 2018
      400,  // 2019
      350,  // 2020
      350,  // 2021
      300,  // 2022
      250,  // 2023
      300,  // 2024
      0,    // 2025 - final (stays forever)
    ];
    
    for (int i = 11; i >= 0; i--) {
      if (!mounted) return;
      
      setState(() {
        _currentLogoIndex = i;
      });
      
      // Trigger animations
      _fadeController.forward(from: 0.0);
      _scaleController.forward(from: 0.0);
      _rotateController.forward(from: 0.0);
      
      // Wait before next transition
      if (i > 0) {
        await Future.delayed(Duration(milliseconds: delays[11 - i]));
      } else {
        // Reached 2025 - stop animating
        setState(() {
          _isAnimating = false;
        });
      }
    }
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32)),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 21, 21, 21),
              Color.fromARGB(255, 21, 21, 21),
            ]
          )
        ),
      child: Column(
        children: [
          SizedBox(height: 8),
          Image.asset(
            "assets/icons/divider.png",
            width: 340,
          ),
          SizedBox(height: 16),
          // Animated Logo Showcase
          SizedBox(
            height: 280,
            child: AnimatedBuilder(
              animation: Listenable.merge([_fadeController, _scaleController, _rotateController]),
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background with glow effect
                    Transform.scale(
                      scale: _scaleAnimation.value * 0.95,
                      child: Opacity(
                        opacity: _fadeAnimation.value * 0.9,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: _currentLogoIndex == 0 ? [
                              BoxShadow(
                                color: Color(0xFFF7B83F).withOpacity(0.4),
                                blurRadius: 80,
                                spreadRadius: 20,
                              ),
                            ] : [],
                          ),
                          child: Image.asset(
                            _logos[_currentLogoIndex]['background']!,
                          ),
                        ),
                      ),
                    ),
                    // Main logo with rotation and scale
                    Transform.rotate(
                      angle: _rotateAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Image.asset(
                            _logos[_currentLogoIndex]['path']!,
                          ),
                        ),
                      ),
                    ),
                    // Pulse effect for final 2025 logo
                    if (_currentLogoIndex == 0 && !_isAnimating)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 2000),
                        curve: Curves.easeInOut,
                        onEnd: () {
                          // This will rebuild and restart the animation
                          if (mounted) setState(() {});
                        },
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 1.0 + (0.03 * (value < 0.5 ? value * 2 : (1 - value) * 2)),
                            child: Opacity(
                              opacity: 0.3 * (value < 0.5 ? value * 2 : (1 - value) * 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xFFF7B83F),
                                    width: 3,
                                  ),
                                ),
                                width: 250,
                                height: 250,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
          // Year Display with smooth transitions
          // AnimatedSwitcher(
          //   duration: const Duration(milliseconds: 400),
          //   transitionBuilder: (child, animation) {
          //     return FadeTransition(
          //       opacity: animation,
          //       child: SlideTransition(
          //         position: Tween<Offset>(
          //           begin: const Offset(0, 0.3),
          //           end: Offset.zero,
          //         ).animate(animation),
          //         child: child,
          //       ),
          //     );
          //   },
          //   child: Container(
          //     key: ValueKey<int>(_currentLogoIndex),
          //     margin: const EdgeInsets.symmetric(vertical: 15),
          //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: _currentLogoIndex == 0 
          //           ? [Color(0xFF00D9FF).withOpacity(0.3), Color(0xFF0066FF).withOpacity(0.3)]
          //           : [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
          //       ),
          //       borderRadius: BorderRadius.circular(25),
          //       border: Border.all(
          //         color: _currentLogoIndex == 0 
          //           ? Color(0xFFF7B83F).withOpacity(0.6)
          //           : Colors.white.withOpacity(0.2),
          //         width: 1.5,
          //       ),
          //       boxShadow: _currentLogoIndex == 0 ? [
          //         BoxShadow(
          //           color: Color(0xFFF7B83F).withOpacity(0.3),
          //           blurRadius: 20,
          //           spreadRadius: 2,
          //         ),
          //       ] : null,
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           'Excel ',
          //           style: GoogleFonts.mulish(
          //             color: Color(0xFFD3E1E4),
          //             fontWeight: FontWeight.w700,
          //             fontSize: 22,
          //           ),
          //         ),
          //         Text(
          //           _logos[_currentLogoIndex]['year']!,
          //           style: GoogleFonts.mulish(
          //             color: _currentLogoIndex == 0 ? Color(0xFFF7B83F) : Color(0xFFFFFFFF),
          //             fontWeight: FontWeight.w900,
          //             fontSize: 26,
          //             letterSpacing: 1.5,
          //             shadows: _currentLogoIndex == 0 ? [
          //               Shadow(
          //                 color: Color(0xFFF7B83F).withOpacity(0.5),
          //                 blurRadius: 10,
          //               ),
          //             ] : null,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.fromLTRB(32, 7, 32, 10),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Inspire. Innovate. Engineer ',
                  style: GoogleFonts.mulish(
                    color: Color(0xFFD3E1E4),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          "\n\nExcel, the nation's second and South India's first ever techno-managerial fest of its kind was started in 2001 by the students of Govt. Model Engineering College, Kochi. Over the years, Excel has grown exponentially, consistently playing host to some of the most talented students, the most coveted guests and the most reputed companies.\nAs we gear up for our 26th edition, Excel continues to push boundaries. Join us this January and experience the magic of a legacy in the making.",
                      style: GoogleFonts.mulish(
                        color: Color(0xFFE4EDEF),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse('https://www.excelmec.org/'));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.black,
                      ),
                      height: 50,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'View Website',
                            style: GoogleFonts.mulish(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.arrow_forward,
                              size: 19, color: Colors.white)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (context.mounted) {
                          showModalBottomSheet<dynamic>(
                            isScrollControlled: true,
                            useRootNavigator: true,
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32),
                              ),
                            ),
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                              maxHeight: MediaQuery.of(context).size.height * 0.9,
                            ),
                            context: context,
                            builder: (context) => const DeveloperCreditsSheet(),
                            isDismissible: true,
                          );
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                      ),
                      height: 50,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Developer Credits',
                            style: GoogleFonts.mulish(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 19,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
          /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/icons/meclogo.png",
                      height: 50,
                    ),
                    Image.asset(
                      "assets/icons/excel2020withtext.png",
                      height: 50,
                    ),
                  ],
                )*/
          ,
        ],
      ),
    );
  }

  static final List<Map<String,String>> _logos = [
    {'year': '2025', 'path': 'assets/logos/2025.png', 'background': 'assets/logos/2025bg.png'},
    {'year': '2024', 'path': 'assets/logos/2024.png', 'background': 'assets/logos/2024bg.png'},
    {'year': '2023', 'path': 'assets/logos/2023.png', 'background': 'assets/logos/2023bg.png'},
    {'year': '2022', 'path': 'assets/logos/2022.png', 'background': 'assets/logos/2022bg.png'},
    {'year': '2021', 'path': 'assets/logos/2021.png', 'background': 'assets/logos/2021bg.png'},
    {'year': '2020', 'path': 'assets/logos/2020.png', 'background': 'assets/logos/2020bg.png'},
    {'year': '2019', 'path': 'assets/logos/2019.png', 'background': 'assets/logos/2019bg.png'},
    {'year': '2018', 'path': 'assets/logos/2018.png', 'background': 'assets/logos/2018bg.png'},
    {'year': '2017', 'path': 'assets/logos/2017.png', 'background': 'assets/logos/2017bg.png'},
    {'year': '2016', 'path': 'assets/logos/2016.png', 'background': 'assets/logos/2016bg.png'},
    {'year': '2015', 'path': 'assets/logos/2015.png', 'background': 'assets/logos/2015bg.png'},
    {'year': '2014', 'path': 'assets/logos/2014.png', 'background': 'assets/logos/2014bg.png'}
  ];
}