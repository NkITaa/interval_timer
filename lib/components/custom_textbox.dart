import 'package:flutter/material.dart';

class CustomTextbox extends StatelessWidget {
  final String label;
  final TextEditingController nameController;
  const CustomTextbox(
      {super.key, required this.label, required this.nameController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
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
