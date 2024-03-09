import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../Themes/colors.dart';

final Uri _url = Uri.parse(
    "geo:10.0283637,76.3263237?q=Government Model Engineering College");

Widget ReachUsModal(context) {
  return Container(
      // margin: EdgeInsets.fromLTRB(0, 40, 0, 10),
      child: Column(
    children: [
      SizedBox(height: 8),
      Image.asset(
        "assets/icons/divider.png",
        width: 340,
      ),
      SizedBox(
        height: 20,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Text(
                "Reach Us",
                style: TextStyle(
                    fontFamily: "mulish",
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    "assets/MapsicleMap.png",
                    width: 320,
                    height: 266,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: _launchUrl,
                  child: Container(
                    width: 320,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: red100,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'View on Google Maps',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "mulish",
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.arrow_forward,
                              size: 19, color: Colors.white)
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  ));
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
