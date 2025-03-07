import 'package:excelapp/UI/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Providers/navigationProvider.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({required this.iconName, required this.text});
  String iconName;
  String text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    required this.items,
    required this.centerItemText,
    this.height = 40,
    this.iconSize = 20.0,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    // this.notchedShape,
    required this.onTabSelected,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  // final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final myNavIndex = Provider.of<MyNavigationIndex>(context);
    _selectedIndex = myNavIndex.getIndex;
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: (i) {
          myNavIndex.setIndex = i;
        },
      );
    });
    // items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items,
        ),
      ),
      color: white100,
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: 30,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 26),
            Text(
              widget.centerItemText,
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(30.0),
            splashColor: white200,
            highlightColor: white200,
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: _selectedIndex == index
                          ? Color(0xFFFC95FE)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  child: Image.asset(
                    _selectedIndex == index
                        ? "assets/icons/${item.iconName}_filled.png"
                        : "assets/icons/${item.iconName}.png",
                    height: 20,
                    // color: _selectedIndex == index
                    //     ? Color(0xFF2C1B77)
                    //     : Color(0xFFAD59AE),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
