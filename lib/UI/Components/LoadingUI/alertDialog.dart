import 'package:excelapp/UI/Components/LoadingUI/loadingAnimation.dart';
import 'package:excelapp/UI/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Loading UI - Alert Dialog
Widget alertBox(String text) {
  return AlertDialog(
    backgroundColor: backgroundBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 50,
          child: LoadingAnimation(),
        ),
        SizedBox(width: 40.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey),
          ),
        )
      ],
    ),
  );
}
