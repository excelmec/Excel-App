import 'dart:async';
import 'package:excelapp/Models/latest_news.dart';
import 'package:excelapp/Services/API/news_api.dart';
import 'package:excelapp/UI/Themes/colors.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:excelapp/UI/Screens/HomePage/Widgets/LatestNews/LatestNews_card.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

GlobalKey<_LatestNewsSectionState> globalKey = GlobalKey();

class LatestNewsSection extends StatefulWidget {
  LatestNewsSection({Key? key}) : super(key: key);
  @override
  State<LatestNewsSection> createState() => _LatestNewsSectionState();
}

class _LatestNewsSectionState extends State<LatestNewsSection> {
  late StreamController<dynamic> estream;
  List<News> news = [];
  bool dataLoaded = false;
  var curr_page = 0;

  bool isLoadMoreRunning = false;
  bool isLastPage = false;

  fetchfromNet(page) async {
    if (!isLoadMoreRunning && !isLastPage) {
      setState(() {
        isLoadMoreRunning = true;
        if (page == 0) {
          curr_page = page;
          news = [];
        }
      });

      try {
        final newItems = await fetchAndStoreNewsFromNet(page, 4);
        await Future.delayed(Duration(seconds: 2));
        isLastPage = newItems.length < 4;
        curr_page += 1;

        if (newItems.isNotEmpty) {
          setState(() {
            news = news + newItems;
            estream.add(newItems);
          });
        }
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    estream = StreamController<dynamic>();
    // initialisePage
    fetchfromNet(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(24, 32, 28, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset("assets/icons/news.png", height: 24),
                    SizedBox(width: 8),
                    Text("Latest News", style: headingStyle),
                  ],
                ),
                Text(
                  "from Excel 2023",
                  style: TextStyle(
                      color: black200,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      fontFamily: pfontFamily),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: estream.stream,
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.data == "error")
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text("Failed to fetch News"),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          onPressed: () {
                            isLoadMoreRunning = false;
                            isLastPage = false;
                            fetchfromNet(curr_page);
                          },
                          child: Text(
                            "Retry",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                );
              if (snapshot.hasData) {
                if (snapshot.data == 0)
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 45),
                    child: Center(
                        child: Text(
                      "No Events",
                      style: TextStyle(color: Colors.black54),
                    )),
                  );
                return Column(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
                      shrinkWrap: true,
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        return LastestNewsCard(news[index]);
                      },
                    ),
                    (isLoadMoreRunning)
                        ? waiting()
                        : (!isLastPage)
                            ? TextButton(
                                onPressed: () => fetchfromNet(curr_page),
                                child: Text(
                                  "Load more",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            : Center(),
                  ],
                );
              } else {
                return Column(
                  children: [
                    SizedBox(height: 24),
                    waiting(),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  waiting() {
    return Column(
      children: [
        shimmer(),
        shimmer(),
      ],
    );
  }

  shimmer() {
    return Shimmer.fromColors(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(32)),
        height: 140,
        margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
      ),
      baseColor: white300,
      highlightColor: white400,
    );
  }
}
