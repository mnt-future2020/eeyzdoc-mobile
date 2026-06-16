import 'package:flutter/material.dart';

import '../../main.dart';

class ScaffoldMessageShow {
  static void show(String message) {
    final context = scaffoldMessengerKey.currentContext;
    if (context == null) return;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: colorScheme.onError,
          ),
        ),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

}
