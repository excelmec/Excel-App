import 'dart:convert';
import 'package:excelapp/Models/event_details.dart';
import 'package:excelapp/Services/API/events_api.dart';
import 'package:excelapp/Services/API/registration_api.dart';
import 'package:excelapp/UI/Components/AlertDialog/alertDialog.dart';
import 'package:excelapp/UI/Components/LoadingUI/loadingAnimation.dart';
import 'package:excelapp/UI/Components/dialogWithContent/dialogWithContent.dart';
import 'package:excelapp/UI/Screens/EventPage/Widgets/changeTeamPage.dart';
import 'package:excelapp/UI/Screens/EventPage/Widgets/createTeamPage.dart';
import 'package:excelapp/UI/Screens/EventPage/Widgets/joinTeamPage.dart';
import 'package:excelapp/UI/Screens/EventPage/Widgets/viewTeam.dart';
import 'package:excelapp/UI/Screens/EventPage/eventPage.dart';
import 'package:excelapp/UI/Screens/HomePage/Widgets/Drawer/drawer.dart';
import 'package:excelapp/UI/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_share/social_share.dart';

// All these commented because raised button deprecated

// The given file contains logic related to registration of event & the button

class RegisterButton extends StatefulWidget {
  final EventDetails eventDetails;
  RegisterButton({@required this.eventDetails});
  @override
  _RegisterButtonState createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  bool registered = false;
  bool isLoading = false;

  reloadPage() {
    EventsAPI.fetchAndStoreEventDetailsFromNet(widget.eventDetails.id);

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EventPage(
    //       widget.eventDetails.id,
    //     ),
    //   ),
    // );
  }

  openJoinTeamPage(int teamID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewTeam(
          eventDetails: widget.eventDetails,
          teamID: teamID,
        ),
      ),
    );
  }

  openChangeTeamPage(int teamID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeTeamPage(
          eventDetails: widget.eventDetails,
          refreshIsRegistered: refreshIsRegistered,
        ),
      ),
    ).then((_) async {
      reloadPage();
      return;
    });
  }

  void refreshIsRegistered() async {
    bool checkIfRegistered =
        await RegistrationAPI.isRegistered(widget.eventDetails.id);
    setState(() {
      registered = checkIfRegistered;
    });
  }

  register(context) async {
    String response = await RegistrationAPI.preRegistration(
        id: widget.eventDetails.id, context: context);
    print("response ${response}");
    if (response == "proceed") {
      // Registers for event
      // If team event, goto join team or create team
      // Else confirmation to registration is asked.
      if (widget.eventDetails.isTeam == 1) {
        await showDialog(
          context: context,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: Text('This is a team event')),
              content: Text(
                "You can either create a team or join a team. ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              actions: <Widget>[
                Center(
                  child: TextButton(
                    child: Text("Register new team"),
                    onPressed: () {
                      Navigator.pop(context);
                      // Register as team page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTeamPage(
                            eventDetails: widget.eventDetails,
                            refreshIsRegistered: refreshIsRegistered,
                          ),
                        ),
                      ).then((_) async {
                        reloadPage();
                        return;
                      });
                    },
                  ),
                ),
                Center(
                  child: TextButton(
                    child: Text("Join existing team"),
                    onPressed: () {
                      Navigator.pop(context);
                      // Register as team page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JoinTeamPage(
                            eventDetails: widget.eventDetails,
                            refreshIsRegistered: refreshIsRegistered,
                          ),
                        ),
                      ).then((_) async {
                        reloadPage();
                        return;
                      });
                      return;
                    },
                  ),
                ),
              ],
            );
          },
        );
      } else {
        // Show confirmation dialog
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Are you sure you want to register ?'),
              content: Text("This cannot be undone."),
              actions: <Widget>[
                TextButton(
                  child: Text("Proceed"),
                  onPressed: () {
                    () async {
                      // Starts loading
                      setState(() {
                        isLoading = true;
                      });

                      await RegistrationAPI.registerEvent(
                        id: widget.eventDetails.id,
                        refreshFunction: refreshIsRegistered,
                        context: context,
                      );

                      // Ends Loading
                      setState(() {
                        isLoading = false;
                      });
                    }();

                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else if (response == 'Already Registered' &&
        widget.eventDetails.isTeam == true) {
      print("Teesting${widget.eventDetails.registration}");
      if (widget.eventDetails.registration == null) {
        print("in If");
        reloadPage();
        return;
      } else if (widget.eventDetails.isTeam == true&&
          widget.eventDetails.registration != null) {
        print("in else if");
        print(widget.eventDetails.toJson());
        print(widget.eventDetails.registration);
        dynamic registrationDetails =
            widget.eventDetails.registration.toString();
        registrationDetails = json.decode(registrationDetails);
        var teamID = registrationDetails["teamId"];
        // var team = registrationDetails["team"];
        print(teamID);
        // DISPLAYS TEAM ID DIALOG
        dialogWithContent(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Share this team Id with your teammates to add them to team",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xaa000000)),
                ),
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 30),
                    Text(
                      "$teamID",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, color: primaryColor),
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
                          text: teamID.toString(),
                        );
                        // alertDialog(text: "Copied", context: context);
                        Fluttertoast.showToast(
                          msg: "Copied",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0x77000000),
                          textColor: Colors.white,
                          fontSize: 11.0,
                        );
                      },
                    )
                  ],
                ),
                SizedBox(height: 35),
                Text(
                  "is your team ID",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xaa000000)),
                ),
                SizedBox(height: 35),
                FractionallySizedBox(
                  widthFactor: .8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      openJoinTeamPage(teamID);
                    },
                    child: Text(
                      "View Team",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: .8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (widget.eventDetails.registrationOpen == true)
                        openChangeTeamPage(teamID);
                      else
                        alertDialog(
                          text:
                              "Registrations for this event has been closed. \n\nTeam change operation cannot be performed.",
                          context: context,
                        );
                    },
                    child: Text(
                      "Change Team",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            context: context);
        // END OF DIALOG
      }
    } else if (response == 'Already Registered')
      alertDialog(
          text: "You have registered for this event.", context: context);
    else {
      // Show returned error
      alertDialog(text: response ?? "Null", context: context);
    }

    refreshIsRegistered();
  }

  @override
  void initState() {
    refreshIsRegistered();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = "";
    Color buttonColor = primaryColor;

    if (widget.eventDetails.needRegistration == true) {
      if (registered) {
        buttonText =
            widget.eventDetails.isTeam == true ? 'Manage Team' : 'Registered';
        buttonColor = registered ? Color(0xff335533) : primaryColor;
      } else if (widget.eventDetails.registrationOpen == true) {
        buttonText = (widget.eventDetails.entryFee == null ||
                widget.eventDetails.entryFee == 0)
            ? 'Register'
            : 'Register for ₹ ${widget.eventDetails.entryFee}';
        buttonColor = primaryColor;
      } else {
        buttonText = "Registration Closed";
        buttonColor = Color(0xff7d141d);
      }
    } else {
      if (widget.eventDetails.button == null) {
        // Should not happen
      } else {
        buttonText = widget.eventDetails.button.toString();
        buttonColor = primaryColor;
      }
    }
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width / 2.3,
      height: 45.0,
      child: Row(children: [
        InkWell(
          onTap: () {
            print("Clicked Button");
            if (widget.eventDetails.needRegistration == true) {
              print("Clicked and need registration true");
              if (registered) {
                print("Clicked and need registration true and registered");
                register(context);
              } else if (widget.eventDetails.registrationOpen == true) {
                register(context);
                print(
                    "Clicked and need registration true and registration open is true");
              } else {
                print('Registration CLosed');
                alertDialog(text: "Registration Closed", context: context);
              }
            } else if (widget.eventDetails.registrationLink != null) {
              launchURL(widget.eventDetails.registrationLink.toString());
            }
          },
          child: Container(
            width: 250,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Color.fromARGB(255, 14, 152, 232),
            ),
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              isLoading
                  ? LoadingAnimation(color: Colors.white)
                  : Row(
                      children: [
                        Text(
                          buttonText ?? '',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "mulish",
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.arrow_forward, size: 19, color: Colors.white)
                      ],
                    ),
              // Text(
              //   widget.eventDetails.needRegistration?
              //   'Register for  ₹ ${widget.eventDetails.entryFee}':'Register',

              //   style: TextStyle(
              //       color: Colors.white,
              //       fontFamily: "mulish",
              //       fontWeight: FontWeight.w700,
              //       fontSize: 14),
              // ),
              // SizedBox(
              //   width: 10,
              // ),
              // Icon(Icons.arrow_forward,
              //     size: 19, color: Colors.white)
            ]),
          ),
        ),
        SizedBox(width: 20),
      ]),

      // ElevatedButton(
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: buttonColor,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(5),
      //     ),
      //   ),
      //   onPressed: () {
      //     if (widget.eventDetails.needRegistration == true) {
      //       if (registered) {
      //         register(context);
      //       } else if (widget.eventDetails.registrationOpen == true) {
      //         register(context);
      //       } else {
      //         alertDialog(text: "Registration Closed", context: context);
      //       }
      //     } else if (widget.eventDetails.registrationLink != null) {
      //       launchURL(widget.eventDetails.registrationLink.toString());
      //     }
      //   },
      //   child: isLoading
      //       ? LoadingAnimation(color: Colors.white)
      //       : Text(
      //           buttonText,
      //           style: TextStyle(color: Colors.white),
      //         ),
      // ),
    );
  }
}
