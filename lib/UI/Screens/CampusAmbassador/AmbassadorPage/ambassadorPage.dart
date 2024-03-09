import 'dart:convert';

import 'package:excelapp/Services/API/campus_ambassador.dart';
import 'package:excelapp/UI/Components/LoadingUI/loadingAnimation.dart';
import 'package:excelapp/UI/Screens/CampusAmbassador/AmbassadorPage/shareOptions.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';

import '../../../../Models/view_user.dart';

class AmbassadorPage extends StatefulWidget {
  final ViewUser userData;
  AmbassadorPage(this.userData);
  @override
  _AmbassadorPageState createState() => _AmbassadorPageState();
}

class _AmbassadorPageState extends State<AmbassadorPage> {
  late ViewUser userData;
  late Future referalList;
  late Map<String, dynamic> ambassadorData;

  @override
  void initState() {
    userData = widget.userData;
    ambassadorData = jsonDecode(userData.ambassador);
    referalList = getReferalList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset("assets/campusAmbassador/refer.png", height: 120),
            SizedBox(height: 20),
            Text(
              "Hello " + userData.name.split(" ")[0] + ",",
              style: TextStyle(fontSize: 22, color: primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 13),
            Text(
              "Share this code to other users\n to add them as referals",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xaa000000)),
            ),
            SizedBox(height: 5),
            // Row with referal code
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 13,
                      color: Colors.grey,
                      spreadRadius: -4,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 25),
                    Text(
                      ambassadorData["id"].toString(),
                      style: TextStyle(fontSize: 27, color: primaryColor),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        Icons.content_copy,
                        size: 28,
                        color: Colors.grey,
                      ),
                      onPressed: () async {
                        await SocialShare.copyToClipboard(
                          text: ambassadorData["id"].toString(),
                        );
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   snackBar("Copied"),
                        // );
                      },
                    )
                  ],
                ),
              ),
            ),
            SharingOptions(referalCode: ambassadorData["id"].toString()),
            // Refered users section
            FutureBuilder(
              future: referalList,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Column(
                    children: [
                      SizedBox(height: 30),
                      Center(
                        child: LoadingAnimation(),
                      ),
                    ],
                  );
                if (snapshot.data == "error") return referalError();
                return Text('snapshot');
                // return ReferedUsers(referedUsers: snapshot.data[]);
              },
            ),
            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }

  Widget referalError() {
    return Center(
      child: Column(
        children: [
          Text(
            "An Error Occured",
            style: TextStyle(
              color: Color(0xaa000000),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: Text(
              "Retry",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AmbassadorPage(userData),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
