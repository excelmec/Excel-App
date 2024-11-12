import 'dart:async';
import 'package:excelapp/Services/API/schedule_api.dart';
import 'package:excelapp/UI/Components/LoadingUI/loadingAnimation.dart';
import 'package:excelapp/UI/Screens/Schedule/Widgets/schedulePage.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/scheduleProvider.dart';
import '../../Themes/colors.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  bool dataLoaded = false;
  late StreamController<dynamic> estream;

  fetchScheduleDetails() async {
    var result2 = await fetchAndStoreScheduleFromNet();
    var result1 = await fetchScheduleFromStorage();
    if (result1 != null) {
      estream.add(result1);
    }

    if (result2 == "error" && result1 == null) {
      estream.add("error");
      return;
    }
    if (result2 == "error") {
      print('error result 2');
      return;
    }
    print("schedule fetched, added to DB & updated in UI");
    estream.add(result2);
    return;
  }

  @override
  void initState() {
    super.initState();
    print('fetch');
    fetchScheduleDetails();
    estream = StreamController<dynamic>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: estream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == "error") {
              return errorRetry();
            }
            return ChangeNotifierProvider(
              create: (context) => ScheduleProvider({}),
              child: SchedulePage(scheduleData: snapshot.data),
            );
          } else {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                //Background Image
                LoadingAnimation()
              ],
            );
          }
        },
      ),
    );
  }

  Widget errorRetry() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Couldn't fetch Schedule",
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
              fetchScheduleDetails();
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
