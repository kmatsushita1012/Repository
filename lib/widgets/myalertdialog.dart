import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String message;

  const MyAlertDialog({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
            style: ButtonStyle(
                side: WidgetStateProperty.all(
                    BorderSide(color: colorScheme.primary))),
            onPressed: () {
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'))
      ],
    );
  }
}
