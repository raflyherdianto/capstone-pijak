import 'package:flutter/material.dart';

class SettingSectionTitle extends StatelessWidget {
  final String title;

  const SettingSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
        letterSpacing: 1.2,
      ),
    );
  }
}
