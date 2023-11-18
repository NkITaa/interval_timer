import 'package:flutter/material.dart';

class CustomTextbox extends StatelessWidget {
  final String label;
  const CustomTextbox({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
