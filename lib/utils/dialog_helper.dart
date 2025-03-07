import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/loading_dialog.dart';

class DialogHelper {
  static Future<void> showLoadingDialog(BuildContext context, {int seconds = 1}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingDialog();
      },
    );

    await Future.delayed(Duration(seconds: seconds));
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
} 