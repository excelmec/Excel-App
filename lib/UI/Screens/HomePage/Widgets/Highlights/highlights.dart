import 'dart:async';
import 'package:excelapp/Services/API/highlights_api.dart';
import 'package:excelapp/UI/Screens/HomePage/Widgets/Highlights/data.dart';
import 'package:flutter/material.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:excelapp/UI/Screens/HomePage/Widgets/Highlights/highlightsBody.dart';

class HighlightsSection extends StatefulWidget {
  @override
  _HighlightsSectionState createState() => _HighlightsSectionState();
}

class _HighlightsSectionState extends State<HighlightsSection> {
  StreamController<dynamic> estream;
  bool dataLoaded = false;

  fetchfromNet() async {
    var dataFromNet = await fetchAndStoreHighlightsFromNet();
    if (!dataLoaded || dataFromNet != "error") {
      //estream.add(dataFromNet);
      estream.add(highlightsData);
      dataLoaded = true;
    }
  }

  // initialisePage() async {
  //   var datafromStorage = await fetchHighlightsFromStorage();
  //   if (datafromStorage != null) {
  //     estream.add(datafromStorage);
  //     dataLoaded = true;
  //   }
  //   await fetchfromNet();
  // }

  @override
  void initState() {
    estream = StreamController<dynamic>();
    // initialisePage();
    fetchfromNet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder(
              stream: estream.stream,
              builder: (context, snapshot) {
                // Handle When no data
                if (snapshot.data == "error")
                  return Container(
                    color: Color(0xffeeeeee),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text("Failed to fetch Highlights"),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            onPressed: () {
                              fetchfromNet();
                            },
                            child: Text(
                              "Retry",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                if (snapshot.hasData)
                  return HighlightsBody(highLightsMap: snapshot.data);
                else {
                  return Container(
                    child: Shimmer.fromColors(
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 4,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                      ),
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
