import 'dart:convert';
import 'package:excelapp/Accounts/getAuthorisedData.dart';
import 'package:excelapp/Accounts/postAuthorisedData.dart';
import 'package:excelapp/Models/event_Team.dart';
import 'package:excelapp/Models/event_card.dart';
import 'package:excelapp/Models/view_user.dart';
import 'package:excelapp/Services/API/api_config.dart';
import 'package:excelapp/UI/Screens/HomePage/Widgets/socialIcons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:excelapp/Services/Database/hive_operations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:excelapp/UI/Components/AlertDialog/alertDialog.dart';

class RegistrationStatus {
  static final RegistrationStatus instance = RegistrationStatus.internal();
  RegistrationStatus.internal();
  // 0 if data not retreived, 1 if data retrieved, 2 if error, -1 if not loggedin, 3 if fetching
  int registeredStatus = 0;
  // Stores registered event ID's
  Set<int> registrationIDs = {};
}

class RegistrationAPI {
  // Gets registrationID's of events

  //have removed void to fix a error
  static fetchRegisteredEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    if (jwt == "null") {
      RegistrationStatus.instance.registeredStatus = -1;
      return;
    }
    RegistrationStatus.instance.registeredStatus = 3;
    var response = await fetchDataFromNet(jwt);
    print('--- Registrations: Fetched from network ---');
    try {
      List data = json.decode(response.body);
      RegistrationStatus.instance.registrationIDs = {};
      for (int i = 0; i < data.length; i++) {
        RegistrationStatus.instance.registrationIDs.add(data[i]['id']);
      }
      RegistrationStatus.instance.registeredStatus = 1;
    } catch (_) {
      RegistrationStatus.instance.registeredStatus = 2;
    }
  }

// List to display Registered Events

  static fetchRegistrations() async {
    print("Fetching registered events");
    var response;
    try {
      response = await getAuthorisedData(APIConfig.baseUrl + 'registration');
      print("Response from fetchRegistrations:${response.statusCode}");
      print("Response from fetchRegistrations:${response.body}");
    } catch (e) {
      print("Error $e");
      return "error";
    }
    if (response.statusCode != 200) return "error";
    List<dynamic> responseData = json.decode(response.body);
    RegistrationStatus.instance.registeredStatus = 1;
    return responseData.map<Event>((event) => Event.fromJson(event)).toList();
  }

  static confirmLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    if (jwt == "null") {
      return false;
    }
    return true;
  }

// Check if an event is registered
  static isRegistered(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogged = prefs.getBool('isLogged') ?? false;
    if (!isLogged)
      return false;
    else if (RegistrationStatus.instance.registrationIDs.contains(id))
      return true;
    else
      return false;
  }

// Recheck if registration possible
  static Future preRegistration({required int id, @required context}) async {
    print("Registration status " +
        RegistrationStatus.instance.registeredStatus.toString());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwt = prefs.getString('jwt');
    if (jwt == "null") {
      return 'Log in to register for events';
    }
    if (RegistrationStatus.instance.registeredStatus == 0) {
      await fetchRegistrations();
      return;
    }
    if (RegistrationStatus.instance.registeredStatus == 3) {
      return 'Could not fetch registration data';
    }
    if (await isRegistered(id)) {
      print("Already registered");
      return 'Already Registered';
    }

    var user = await HiveDB.retrieveData(valueName: "user");
    if (user == null) return "Login";
    if (ViewUser.fromJson(user).gender == "null" ||
        ViewUser.fromJson(user).institutionName == "null") {
      return "Update profile to register for events.";
    }

    return "proceed";
  }

// Registers event
  static Future registerEvent(
      {required int id,
      required var teamId,
      required var ambassadorId,
      @required refreshFunction,
      @required context}) async {
    var requestBody;
    requestBody = json.encode(
        {"eventId": id, "teamId": teamId, "ambassadorId": ambassadorId});
    try {
      print(requestBody);
      var response = await postAuthorisedData(
        url: APIConfig.baseUrl + 'registration',
        body: requestBody,
      );
      print(response.body);
      print("Registration over with status code " +
          response.statusCode.toString());
      if (response.statusCode == 469) {
        Fluttertoast.showToast(
          msg: "Please retry after completing the profile",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          fontSize: 16,
        );
        launchURL(
            "https://auth.excelmec.org/auth/logout?redirect_to=https://accounts.excelmec.org/complete-profile");
      }
      if (response.statusCode != 200) return response;

      RegistrationStatus.instance.registrationIDs.add(id);
      refreshFunction();
    } catch (_) {
      alertDialog(
          text: 'Operation failed. Check network connection.',
          context: context);
      return -1;
    }
  }

  static Future createTeam(String teamName, int eventId) async {
    print(json.encode({"name": teamName, "eventId": eventId}));
    try {
      var response = await postAuthorisedData(
        url: APIConfig.baseUrl + 'Team',
        body: json.encode({"name": teamName, "eventId": eventId}),
      );
      print("Create team status code " + response.statusCode.toString());
      if (response.statusCode == 469) {
        Fluttertoast.showToast(
          msg: "Please Retry after completing the profile",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          fontSize: 16,
        );
        launchURL(
            "https://auth.excelmec.org/auth/logout?redirect_to=https://accounts.excelmec.org/complete-profile");
      }
      if (response.statusCode != 200) return;
      TeamDetails teamDetails = TeamDetails.fromJson(jsonDecode(response.body));
      return teamDetails;
    } catch (_) {
      return;
    }
  }
}

// Fetches data from net & retries if fails
Future fetchDataFromNet(jwt) async {
  http.Response res;
  try {
    res = await getAuthorisedData(APIConfig.baseUrl + 'registration');
    return res;
  } catch (_) {
    await Future.delayed(Duration(milliseconds: 2000), () async {
      res = await fetchDataFromNet(jwt);
    });
    return "success";
  }
}
