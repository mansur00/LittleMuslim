import 'package:flutter/material.dart';

Widget buildBadShadowAndElevation(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(color: Color(0x33000000), blurRadius: 8),
      ],
    ),
    child: const Material(
      elevation: 4.0,
      child: SizedBox(height: 50),
    ),
  );
}
