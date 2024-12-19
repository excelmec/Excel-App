import 'package:excelapp/UI/Themes/gradient.dart';

import '../../../Themes/colors.dart';
import 'package:flutter/material.dart';

Widget page(context, title, description, image, {extra = const Center()}) {
  return Container(
    height: MediaQuery.of(context).size.width * 1.45,
    width: MediaQuery.of(context).size.width * 0.9,
    margin: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: landingGradient()
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        image,
        const SizedBox(height: 24),
        Text(
          title,
          style: TextStyle(
            color: white100,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            fontFamily: "mulish",
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 33),
          child: Column(
            children: [
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: white200,
                  fontFamily: "mulish",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              extra
            ],
          ),
        )
      ],
    ),
  );
}