import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class FlutterGeneralServices {
  static Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  static showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: kSnackStyle,
      ),
      backgroundColor: Colors.grey[300],
    ));
  }
}
