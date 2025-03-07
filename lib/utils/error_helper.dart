import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/error_dialog.dart';

class ErrorHelper {
  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      return 'An error occurred while loading trips. Please try again.';
    } else if (error is String) {
      return error;
    }
    return 'Unknown error occurred. Please try again.';
  }

  static void showErrorDialog(
    BuildContext context,
    dynamic error,
    VoidCallback onRetry,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ErrorDialog(
          message: getErrorMessage(error),
          onRetry: onRetry,
        );
      },
    );
  }
} 