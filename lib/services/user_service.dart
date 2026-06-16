import 'dart:convert';
import 'package:docuflow/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import '../constants/globals.dart' as globals;
import '../constants/urlConstants.dart' as urlConstants;

class UserService {
  static Future<Map<String, dynamic>> resetPassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(urlConstants.resetPasswordUrl),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer ${AppConstants.AUTH_TOKEN}",
        },
        body: {"oldPassword": oldPassword, "newPassword": newPassword},
      );
      var result = json.decode(response.body);
      return result;
    } catch (e) {
      return {
        "status": "error",
        "message": "An error occurred. Please try again later.",
      };
    }
  }
}
