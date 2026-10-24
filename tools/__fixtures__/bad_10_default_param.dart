import 'package:flutter/material.dart';

class BadDefaultParamWidget extends StatelessWidget {
  final String title;
  const BadDefaultParamWidget({super.key, this.title = 'User Settings'});

  @override
  Widget build(BuildContext context) => Text(title);
}
