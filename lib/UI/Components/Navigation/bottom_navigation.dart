import 'package:excelapp/UI/Themes/colors.dart';
import 'package:flutter/material.dart';
import './BottomNavigationBarWidget/fab_bottom_app_bar.dart';

enum TabItem { page1, page2, page3, page4 }

Map<TabItem, int> tabName = {
  TabItem.page1: 0,
  TabItem.page2: 1,
  TabItem.page3: 2,
  TabItem.page4: 3,
};

class BottomNavigation extends StatelessWidget {
  BottomNavigation({required this.selectedIndex, required this.onSelect});
  final int selectedIndex;
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return FABBottomAppBar(
      centerItemText: 'Home',
      color: white100,
      selectedColor: red50,
      onTabSelected: onSelect,
      items: [
        FABBottomAppBarItem(iconName: "home", text: ''),
        FABBottomAppBarItem(iconName: "discovery", text: ''),
        FABBottomAppBarItem(iconName: "calendar", text: ''),
        FABBottomAppBarItem(iconName: "profile", text: ''),
      ],
      backgroundColor: white100,
    );
  }
}
