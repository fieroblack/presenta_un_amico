import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class FlutterGeneralServices {
  static Future<dynamic> buildProgressIndicator(BuildContext context) {
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

  static showMaterialBanner(BuildContext context, String text, Function func) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          text,
          style: kSnackStyle,
        ),
        actions: [
          TextButton(
              onPressed: () {
                func();
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('Si')),
          TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('No'))
        ],
      ),
    );
  }
}
