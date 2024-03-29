import 'dart:io';
import 'package:excelapp/Accounts/refreshToken.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// The following function Refreshes Access token/JWT
// If it has been expired

putAuthorisedData({required String url, body}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jwt = prefs.getString('jwt');
  var response = await http.put(Uri.parse(
    url),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer " + jwt!,
      "Content-Type": "application/json"
    },
    body: body,
  );
  print(response.statusCode);
  // If token has expired, rfresh it
  if (response.statusCode == 455 || response.statusCode == 500 || response.statusCode == 401) {
    // Refreshes Token & gets JWT
    jwt = await refreshToken();
    // Retrying Request
    response = await http.put(Uri.parse(
      url),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer " + jwt!,
        "Content-Type": "application/json"
      },
      body: body,
    );
  }
  return response;
}
