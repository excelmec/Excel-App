import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

class AuthService {
  static Future<String> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late String accessToken;
    try {
      GoogleSignIn googleSignIn = GoogleSignIn.instance;
      googleSignIn.initialize();
      await googleSignIn.signOut();
      await googleSignIn.disconnect();
      GoogleSignInAccount? accountInfo = await googleSignIn.authenticate();
      GoogleSignInClientAuthorization? googleKeys = await accountInfo
          .authorizationClient
          .authorizationForScopes(['email', 'profile']);
      if (googleKeys?.accessToken == null) {
        throw Exception('Failed to obtain access token from Google Sign-In');
      }
      accessToken = googleKeys?.accessToken ?? '';
    } catch (err) {
      throw Exception('Google Sign-In failed: $err');
    }
    try {
      Map<String, String> token = {"accessToken": accessToken};
      var response = await http.post(
        Uri.parse("https://accounts-api.excelmec.org/api/Auth/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(token),
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Server responded with status code: ${response.statusCode}',
        );
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      String jwt = responseData['accessToken'].toString();
      String refreshToken = responseData['refreshToken'].toString();
      prefs.setString('jwt', jwt);
      prefs.setString('refreshToken', refreshToken);
      prefs.setBool('isLogged', true);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
    return 'success';
  }

  static Future<String> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('jwt');
    await prefs.setBool('isLogged', false);
    return 'success';
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt');
    return token ?? '';
  }
}
