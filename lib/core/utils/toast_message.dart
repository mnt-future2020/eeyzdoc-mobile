import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static void show(String message) {
    Fluttertoast.cancel();

    // Limit to roughly 2 lines (adjust 80-100 chars as needed)
    if (message.length > 100) {
      message = '${message.substring(0, 97)}...';
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[850],
      textColor: Colors.white,
      fontSize: 14.0,
      timeInSecForIosWeb: 2,
    );
  }
}