import 'package:excelapp/Providers/navigationProvider.dart';
import 'package:excelapp/UI/Screens/ExplorePage/Widgets/Components/tabs.dart';
import 'package:excelapp/UI/Screens/ExplorePage/Widgets/Events/allEvents.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsCardList extends StatefulWidget {
  @override
  State<EventsCardList> createState() => _EventsCardListState();
  final String selectedTab;
  final String txtQuery;
  const EventsCardList({Key? key, required this.selectedTab, required this.txtQuery})
      : super(key: key);
}

class _EventsCardListState extends State<EventsCardList>
    with SingleTickerProviderStateMixin {
  late String selectedCategory;
  List<String> tabs = ["All", "Workshops", "Talks", "General"];

  @override
  void initState() {
    super.initState();
    // selectedCategory = widget.selectedTab ?? "all";
  }

  @override
  Widget build(BuildContext context) {
    final _myNavIndex = Provider.of<MyNavigationIndex>(context);
    selectedCategory = _myNavIndex.getExplorerCategory;
    print("I want this " + _myNavIndex.getExplorerCategory);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: tabs
                    .map((tabItem) => FilterTab(
                          isSelected: selectedCategory == tabItem.toLowerCase(),
                          text: tabItem,
                          onPressed: () {
                            setState(() {
                              _myNavIndex
                                  .setJustCategory(tabItem.toLowerCase());
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            AllEvents(
              category: selectedCategory,
              txtQuery: widget.txtQuery,
            )
          ],
        ),
      ),
    );
  }
}
