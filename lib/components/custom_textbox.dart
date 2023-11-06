import 'package:flutter/material.dart';

class CustomTextbox extends StatelessWidget {
  final String label;
  const CustomTextbox({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
