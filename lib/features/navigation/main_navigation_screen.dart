import 'package:excelapp2025/features/calendar/view/calendar_screen.dart';
import 'package:excelapp2025/features/discover/view/discover_screen.dart';
import 'package:excelapp2025/features/home/cubit/index_cubit.dart';
import 'package:excelapp2025/features/home/view/home_content.dart';
import 'package:excelapp2025/features/home/widgets/excel_sheet.dart';
import 'package:excelapp2025/features/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<Widget> _screens = const [
    HomeContent(),
    DiscoverScreen(),
    CalendarScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndexCubit, IndexState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              IndexedStack(index: state.navBarIndex, children: _screens),
              _buildCustomBottomNavBar(state.navBarIndex),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomBottomNavBar(int selectedNavIndex) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    index: 0,
                    iconPath: 'assets/icons/home.png',
                    isSelected: selectedNavIndex == 0,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 1,
                    iconPath: 'assets/icons/discover.png',
                    isSelected: selectedNavIndex == 1,
                  ),
                ),
                const SizedBox(width: 88),
                Expanded(
                  child: _buildNavItem(
                    index: 2,
                    iconPath: 'assets/icons/calendar.png',
                    isSelected: selectedNavIndex == 2,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 3,
                    iconPath: 'assets/icons/user.png',
                    isSelected: selectedNavIndex == 3,
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
                    child: InkWell(
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
                          builder: (context) =>
                              Wrap(children: const <Widget>[AboutExcelPopUp()]),
                          isDismissible: true,
                        );
                      },
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
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required bool isSelected,
  }) {
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
