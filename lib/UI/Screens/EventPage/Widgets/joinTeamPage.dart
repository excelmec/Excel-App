import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:excelapp/Accounts/refreshToken.dart';
import 'package:excelapp/Models/event_details.dart';
import 'package:excelapp/Services/API/events_api.dart';
import 'package:excelapp/Services/API/registration_api.dart';
import 'package:excelapp/UI/Components/AlertDialog/alertDialog.dart';
import 'package:excelapp/UI/Components/LoadingUI/loadingAnimation.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:excelapp/Services/API/api_config.dart';

class JoinTeamPage extends StatefulWidget {
  final EventDetails eventDetails;
  final Function refreshIsRegistered;
  JoinTeamPage(
      {required this.eventDetails, required this.refreshIsRegistered});
  @override
  _JoinTeamPageState createState() => _JoinTeamPageState();
}

class _JoinTeamPageState extends State<JoinTeamPage> {
  final _formKey = GlobalKey<FormState>();
  late int teamID;
  String referralID = "";
  bool isLoading = false;
  registerEvent() async {
    var registered = await RegistrationAPI.registerEvent(
      ambassadorId: referralID,
      id: widget.eventDetails.id,
      teamId: teamID,
      refreshFunction: widget.refreshIsRegistered,
      context: context,
    );
    print(registered);
    if (referralID != "") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? jwt = prefs.getString('jwt');
        print(jwt);
        var body = {
          "eventId": widget.eventDetails.id,
          "referrerId": int.parse(referralID),
          "accessToken": jwt,
          "point": 10
        };
        print(json.encode(body));
        var response = await http.post(
            Uri.parse(APIConfig.cabaseUrl + "addTransactionByToken"),
            body: json.encode(body),
            headers: {
              "content-type": "application/json",
            });
        print(response.statusCode);
        // If token has expired, rfresh it
        if (response.statusCode == 455 || response.statusCode == 500) {
          // Refreshes Token & gets JWT
          jwt = await refreshToken();
          var body = {
            "eventId": widget.eventDetails.id,
            "referrerId": int.parse(referralID),
            "accessToken": jwt,
            "point": 10
          };
          // Retrying Request
          response = await http.post(
              Uri.parse(APIConfig.cabaseUrl + "addTransactionByToken"),
              body: json.encode(body),
              headers: {
                "content-type": "application/json",
              });
        }
        if (response.statusCode == 200) {
          print("Transaction added");
          print(response.body);
        } else {
          print("Transaction not added");
        }
      }
    if (registered == -1) {
      print("Joining failed");
    } else if (registered != null && registered.statusCode != 200) {
      try {
        alertDialog(
          text: jsonDecode(registered.body)["error"].toString(),
          context: context,
        );
      } catch (_) {
        alertDialog(text: "Registration failed. Try again", context: context);
      }
    } else {
      EventsAPI.fetchAndStoreEventDetailsFromNet(widget.eventDetails.id);
      await Future.delayed(Duration(milliseconds: 200));
      Navigator.pop(context);
      return;
    }
    setState(() {
      isLoading = false;
    });
  }

  onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });
    await registerEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        shadowColor: null,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: secondaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleTextStyle: TextStyle(
          color: secondaryColor,
          fontFamily: pfontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        title: Text("Join Team"),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: primaryColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                Hero(
                  tag: '${widget.eventDetails.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      color: Color.fromARGB(255, 14, 152, 232),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.25),
                      child: ClipRRect(
                        //Change this to Image.network when image server is up
                        // child: Image.asset(
                        //   "assets/events/eventLogo.png",
                        //   //event.icon,
                        //   width: 31.5,
                        //   height: 31.5,
                        // ),
                        child:(widget.eventDetails.icon.startsWith("Microsoft"))?(
                          Image.asset(
                            "assets/events/eventLogo.png",
                            //event.icon,
                            width: 31.5,
                            height: 31.5,
                          )
                        ): CachedNetworkImage(
                          imageUrl: widget.eventDetails.icon,
                          width: 31.5,
                          height: 31.5,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "You are about to join a team for the event " +
                      widget.eventDetails.name.toString() +
                      ".",
                  style: TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "You can get the team code by asking other team members.",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: lightTextColor,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [TextFormField(
                      style: TextStyle(fontFamily: pfontFamily, fontSize: 15),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        setState(() {
                          teamID = int.parse(value);
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter ID of the required team to join";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Enter ID of team to join",
                        icon: Icon(Icons.edit),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),SizedBox(height: 20),
                    TextFormField(
                        style: TextStyle(fontFamily: pfontFamily, fontSize: 15),
                        onChanged: (String value) {
                          setState(() {
                            referralID = value.trim();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Enter Referral ID (Optional)",
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),  
                    ],
                  ),
                ),
                SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 60,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            onSubmit();
                          },
                    child: isLoading
                        ? LoadingAnimation(color: Colors.white)
                        : Text(
                            "Submit",
                            style: TextStyle(
                                fontFamily: "mulish",
                                fontSize: 14,
                                color: Color.fromARGB(255, 251, 255, 255),
                                fontWeight: FontWeight.w700),
                          ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
