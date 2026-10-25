import 'package:flutter/material.dart';

Widget buildBadSpacing() {
  return const Padding(
    padding: EdgeInsets.all(16.0), // Hardcoded EdgeInsets spacing
    child: SizedBox(height: 20), // Hardcoded SizedBox spacer
  );
}
