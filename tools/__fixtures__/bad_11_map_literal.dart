import 'package:flutter/material.dart';

final badDataMap = {
  'title': 'Welcome home',
  'desc': 'Pehla sabak',
};

Widget buildBadMapWidget() {
  return Text(badDataMap['title']!);
}
