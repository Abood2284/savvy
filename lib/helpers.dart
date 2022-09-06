import 'dart:math';

import 'package:flutter/material.dart';

abstract class Helpers {
  static final random = Random();

  static String randomPictureUrl() {
    final randomInt = random.nextInt(1000);
    return 'https://picsum.photos/seed/$randomInt/200/200';
  }

  static DateTime randomDateTime() {
    final randomInt = random.nextInt(20000000);
    return DateTime.now().subtract(Duration(seconds: randomInt));
  }

  static void ShowDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
