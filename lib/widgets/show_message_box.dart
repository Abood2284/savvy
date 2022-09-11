import 'package:flutter/material.dart';

enum STATUS {
  success,
  error,
}

Future<void> showDialogBox(BuildContext context, status) async {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        status == status.success ? 'success' : 'error',
      ),
      content: Text(
        status == status.success
            ? 'LogIn Succesfull'
            : 'We encountered an error',
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop(true);
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}
