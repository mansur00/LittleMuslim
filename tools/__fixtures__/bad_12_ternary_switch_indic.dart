import 'package:flutter/material.dart';

String getBadgeText(bool isPassed, int code) {
  final label = isPassed ? 'সফল হয়েছে' : 'ব্যর্থ হয়েছে';
  switch (code) {
    case 1:
      return 'पहला पाठ';
    default:
      return label;
  }
}

Widget buildBadTernarySwitchWidget() {
  return Text(getBadgeText(true, 1));
}
