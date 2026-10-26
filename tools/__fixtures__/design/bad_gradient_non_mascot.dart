import 'package:flutter/material.dart';

Widget buildBadGradient(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF00FF00), Color(0xFF0000FF)],
      ),
    ),
  );
}
