import 'package:flutter/material.dart';

Widget buildBannedWidgets(BuildContext context) {
  return Column(
    children: [
      ElevatedButton(onPressed: () {}, child: const Text('Bad')),
      const TextField(),
      Switch(value: true, onChanged: (_) {}),
      const Chip(label: Text('Tag')),
      const SnackBar(content: Text('Alert')),
      const AlertDialog(title: Text('Prompt')),
    ],
  );
}
