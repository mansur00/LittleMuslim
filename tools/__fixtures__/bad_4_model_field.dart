import 'package:flutter/material.dart';

Widget buildBadWidget() {
  return Container(
    child: _BadCard(
      title: 'User Settings Screen',
    ),
  );
}

class _BadCard extends StatelessWidget {
  final String title;
  const _BadCard({required this.title});
  @override
  Widget build(BuildContext context) => Text(title);
}
