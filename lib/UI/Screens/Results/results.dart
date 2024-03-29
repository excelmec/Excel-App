import 'dart:async';
import 'dart:convert';
import 'package:excelapp/Services/API/api_config.dart';
import 'package:excelapp/UI/Components/LoadingUI/loadingAnimation.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:flutter/material.dart';
import 'package:excelapp/Models/event_card.dart';
import 'package:http/http.dart' as http;

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late Future results;

  @override
  void initState() {
    super.initState();
    results = fetchResults();
  }

  Future fetchResults() async {
    print("- Results network fetch");
    try {
      var response =
          await http.get(Uri.parse(APIConfig.baseUrl + "/events/results_out"));
      if (response.statusCode != 200) return "error";
      var responseData = json.decode(response.body);
      return responseData.map<Event>((event) => Event.fromJson(event)).toList();
    } catch (e) {
      print("Error $e");
      return ("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: customappbar("Results"),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: results,
              builder: (context, snapshot) {
                // return Text(snapshot.data.toString());
                // If no internet & not stored
                if (snapshot.data == "error") return errorRetry();
                Object? list = snapshot.data;
                // If data is present
                if (snapshot.hasData) {
                  // If no events
                  if (list == 0)
                    return Center(
                      child: Text(
                        "No results have been published.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    );

                  return ListView(
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    children: <Widget>[
                          SizedBox(height: 20),
                        ] +
                        List.generate(
                          14,
                          (index) {
                            // return ResultCard(
                            //   list![index],
                            // );
                            return Text('resultCard', style: TextStyle());
                          },
                        ) +
                        <Widget>[
                          SizedBox(height: 60),
                        ],
                  );
                } else {
                  return LoadingAnimation();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget errorRetry() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Failed to load. Please retry",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsPage(),
                ),
              );
            },
            child: Text(
              "Retry",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
