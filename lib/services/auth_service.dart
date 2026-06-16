import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/globals.dart' as globals;
import '../constants/urlConstants.dart' as urlConstants;

class AuthService {
  static Future<bool> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(urlConstants.authUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
         // globals.token = data["authorisation"]["token"];
         
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(urlConstants.forgotPasswordUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"email": email},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["message"] != null) {
          return data["message"];
        } else {
          return "Unknown response from server.";
        }
      } else {
        return "Failed to send reset link. Please try again.";
      }
    } catch (e) {
      return "An error occurred. Please try again later.";
    }
  }
}
