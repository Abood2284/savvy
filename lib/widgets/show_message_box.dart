import 'package:flutter/material.dart';

enum STATUS {
  Success,
  Error,
}

Future<void> showDialogBox(BuildContext context, status) async {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        status == status.Success ? 'Success' : 'Error',
      ),
      content: Text(
        status == status.Success
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
