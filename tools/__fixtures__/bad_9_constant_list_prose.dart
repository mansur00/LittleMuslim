import 'package:flutter/material.dart';

// English sentence appears inside a data-model constant list
const List<String> letterDescriptions = [
  'The first letter of the Arabic alphabet.',
];

Widget buildBadListWidget() {
  return Text(letterDescriptions[0]);
}
