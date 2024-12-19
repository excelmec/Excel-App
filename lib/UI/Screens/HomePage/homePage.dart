import 'package:excelapp/UI/Screens/HomePage/Widgets/Discover/discover.dart';
import 'package:excelapp/UI/Screens/HomePage/Widgets/Highlights/highlights.dart';
import 'package:excelapp/UI/Screens/HomePage/Widgets/home_appBar.dart';
import 'package:excelapp/UI/Themes/colors.dart';
import 'package:excelapp/UI/Themes/gradient.dart';
import 'package:flutter/material.dart';
import 'package:excelapp/UI/Screens/HomePage/Widgets/QuickAccess/quickAccess.dart';
import 'Widgets/LatestNews/latestNews.dart';
import 'Widgets/CampusAmbassador/campusAmb.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: white100,
      body: Container(
        decoration: BoxDecoration(
          gradient: primaryGradient()
        ),

        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Container(),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => globalKey.currentState!.fetchfromNet(0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: primaryGradient()
                    ),
                    // color: white200,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: [
                              ExcelTitle(),
                              QuickAccessBar(),
                              HighlightsSection(),
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: white300, width: 1.2)),
                          ),
                        ),
                        
                        Discover(),
                        CampusAmbassador(),
                        LatestNewsSection(
                          key: globalKey,
                        ),
                        const SizedBox(height: 30)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
