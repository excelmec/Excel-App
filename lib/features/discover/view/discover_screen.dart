import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _mainTabIndex = 0; // 0 for Events, 1 for Competitions
  int _categoryIndex = 0; // Index for category tabs
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _eventCategories = ['All', 'Workshops', 'Talks', 'General'];
  final List<String> _competitionCategories = ['All', 'CS-Tech', 'Gen-Tech', 'Non-Tech'];

  List<String> get _currentCategories =>
      _mainTabIndex == 0 ? _eventCategories : _competitionCategories;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/discover_bg.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTopBar(),
                const SizedBox(height: 15),
                _buildCategoryTabs(),
                const SizedBox(height: 20),
                Expanded(
                  child: _buildEventsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: _isSearchExpanded ? 0 : MediaQuery.of(context).size.width - 112,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isSearchExpanded ? 0.0 : 1.0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _mainTabIndex = 0;
                            _categoryIndex = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _mainTabIndex == 0
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              'Events',
                              style: GoogleFonts.mulish(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _mainTabIndex = 1;
                            _categoryIndex = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _mainTabIndex == 1
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              'Competitions',
                              style: GoogleFonts.mulish(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: _isSearchExpanded ? 0 : 12,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: _isSearchExpanded ? MediaQuery.of(context).size.width - 40 : 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: _isSearchExpanded
                  ? Row(
                      key: const ValueKey('search_expanded'),
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSearchExpanded = false;
                              _searchController.clear();
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: GoogleFonts.mulish(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: GoogleFonts.mulish(
                                color: Colors.white60,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          ),
                      ],
                    )
                  : IconButton(
                      key: const ValueKey('search_collapsed'),
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          _isSearchExpanded = true;
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _currentCategories.length,
        itemBuilder: (context, index) {
          final isSelected = _categoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _categoryIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFF7B83F)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFF7B83F)
                        : Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    _currentCategories[index],
                    style: GoogleFonts.mulish(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventsList() {
    // Placeholder for events list
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_mainTabIndex == 0 ? "Event" : "Competition"} Title ${index + 1}',
                style: GoogleFonts.mulish(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Category: ${_currentCategories[_categoryIndex]}',
                style: GoogleFonts.mulish(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFF7B83F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Description of the ${_mainTabIndex == 0 ? "event" : "competition"} goes here...',
                style: GoogleFonts.mulish(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}