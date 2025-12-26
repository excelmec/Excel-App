import 'package:excelapp2025/features/discover/bloc/discover_bloc.dart';
import 'package:excelapp2025/features/discover/bloc/discover_event.dart';
import 'package:excelapp2025/features/discover/bloc/discover_state.dart';
import 'package:excelapp2025/features/discover/widgets/discover_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DiscoverBloc>().add(LoadEventsEvent());
    return const DiscoverScreenView();
  }
}

class DiscoverScreenView extends StatefulWidget {
  const DiscoverScreenView({super.key});

  @override
  State<DiscoverScreenView> createState() => _DiscoverScreenViewState();
}

class _DiscoverScreenViewState extends State<DiscoverScreenView> {
  int _mainTabIndex = 0; // 0 for Events, 1 for Competitions
  int _categoryIndex = 0; // Index for category tabs
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _eventCategories = [
    'All',
    'Workshops',
    'Talks',
    'General',
  ];
  final List<String> _competitionCategories = [
    'All',
    'CS-Tech',
    'Gen-Tech',
    'Non-Tech',
  ];

  List<String> get _currentCategories =>
      _mainTabIndex == 0 ? _eventCategories : _competitionCategories;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<DiscoverBloc>().add(
      SearchEventsEvent(query: _searchController.text),
    );
    setState(() {}); // Rebuild to show/hide clear icon
  }

  void _updateFilter() {
    final type = _mainTabIndex == 0 ? 'events' : 'competitions';
    final category = _currentCategories[_categoryIndex];
    context.read<DiscoverBloc>().add(
      FilterEventsByCategoryEvent(category: category, type: type),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/discover_bg.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTopBar(),
                const SizedBox(height: 15),
                _buildCategoryTabs(),
                const SizedBox(height: 20),
                Expanded(child: _buildEventsList()),
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
            width: _isSearchExpanded
                ? 0
                : MediaQuery.of(context).size.width - 112,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isSearchExpanded ? 0.0 : 1.0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white, width: 1.5),
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
                          _updateFilter();
                        },
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Spacer(),
                              Text(
                                'Events',
                                style: GoogleFonts.mulish(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                height: 2,
                                width: _mainTabIndex == 0 ? 80 : 0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ],
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
                          _updateFilter();
                        },
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Spacer(),
                              Text(
                                'Competitions',
                                style: GoogleFonts.mulish(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                height: 2,
                                width: _mainTabIndex == 1 ? 80 : 0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ],
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
            width: _isSearchExpanded
                ? MediaQuery.of(context).size.width - 40
                : 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
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
                              hintText: _mainTabIndex == 0
                                  ? 'Search for Events'
                                  : 'Search for Competitions',
                              hintStyle: GoogleFonts.mulish(
                                color: Colors.white60,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
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
      height: 40,
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
                _updateFilter();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFF7B83F)
                      : Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFF7B83F)
                        : Colors.white.withOpacity(0.9),
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
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        if (state is DiscoverLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF7B83F)),
            ),
          );
        }

        if (state is DiscoverError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white70,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load events',
                  style: GoogleFonts.mulish(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: GoogleFonts.mulish(
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is DiscoverLoaded) {
          if (state.filteredEvents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, color: Colors.white70, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'No events found',
                    style: GoogleFonts.mulish(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.filteredEvents.length,
            itemBuilder: (context, index) {
              final event = state.filteredEvents[index];
              return DiscoverCard(event: event);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
