import 'package:flutter/material.dart';

Widget darkAppbar({required Color color}) {
  return PreferredSize(
    child: AppBar(
      backgroundColor: color,
      elevation: 0,
    ),
    preferredSize: Size.fromHeight(0),
  );
}
