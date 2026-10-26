import 'package:flutter/material.dart';

Widget buildBadCardBorder(BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
    ),
    child: const SizedBox(height: 60),
  );
}
