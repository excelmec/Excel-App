import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:excelapp/Accounts/refreshToken.dart';
import 'package:excelapp/Models/event_Team.dart';
import 'package:excelapp/Models/event_details.dart';
import 'package:excelapp/Services/API/api_config.dart';
import 'package:excelapp/Services/API/events_api.dart';
import 'package:excelapp/Services/API/registration_api.dart';
import 'package:excelapp/UI/Components/AlertDialog/alertDialog.dart';
import 'package:excelapp/UI/Components/LoadingUI/loadingAnimation.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Themes/colors.dart';

class CreateTeamPage extends StatefulWidget {
  final EventDetails eventDetails;
  final Function refreshIsRegistered;
  CreateTeamPage(
      {required this.eventDetails, required this.refreshIsRegistered});
  @override
  _CreateTeamPageState createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  final _formKey = GlobalKey<FormState>();
  String teamName = "";
  String referralID = "";
  bool isLoading = false;



  createTeam() async {
    TeamDetails teamdetails =
        await RegistrationAPI.createTeam(teamName, widget.eventDetails.id);
        
    var registered = await RegistrationAPI.registerEvent(
      id: widget.eventDetails.id,
      teamId: teamdetails.id,
      ambassadorId: referralID,
      refreshFunction: widget.refreshIsRegistered,
      context: context,
    );
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
      if (response.statusCode == 455 || response.statusCode == 500 || response.statusCode == 401) {
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
    if (registered == -1)
      print("Error occured");
    else if (registered != null && registered.statusCode != 200) {
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
    await createTeam();
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
        title: Text("Create Team"),
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
                      color: red100,
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
                        child:
                            (widget.eventDetails.icon.startsWith("Microsoft"))
                                ? (Image.asset(
                                    "assets/events/eventLogo.png",
                                    //event.icon,
                                    width: 31.5,
                                    height: 31.5,
                                  ))
                                : CachedNetworkImage(
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
                  "You are about to create a team for the event " +
                      widget.eventDetails.name.toString() +
                      ".",
                  style: TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "If there is an existing team which you wish to join, go back and enter the team code of the team to join.",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: lightTextColor,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(fontFamily: pfontFamily, fontSize: 15),
                        onChanged: (String value) {
                          setState(() {
                            teamName = value.trim();
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter a team name";
                          }
                          if (value.trim().length < 5) {
                            return "Enter atleast 5 characters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Enter Team Name",
                          icon: Icon(Icons.edit),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      SizedBox(height: 20),
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
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
