import 'package:flutter/material.dart';
Widget buildGoodWidget() {
  return Container(
    key: const Key('settings_container_key'),
    decoration: const BoxDecoration(
      image: DecorationImage(image: AssetImage('assets/images/logo.png')),
    ),
    child: const Text('NotoSansBengali', style: TextStyle(fontFamily: 'NotoSansBengali')),
  );
}
