import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncrementDecrementButton extends StatefulWidget {
  const IncrementDecrementButton({super.key});

  @override
  State<IncrementDecrementButton> createState() =>
      _IncrementDecrementButtonState();
}

class _IncrementDecrementButtonState extends State<IncrementDecrementButton> {
  DateTime minutes = DateTime(0, 0, 0, 0, 1, 0);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                minutes = minutes.subtract(const Duration(seconds: 15));
              });
            },
            child: const Text('-'),
          ),
          Container(
            width: 100,
            child: Column(
              children: [
                Text("Training"),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                  ),
                  child: Text(DateFormat('mm:ss').format(minutes)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                minutes = minutes.add(const Duration(seconds: 15));
              });
            },
            child: const Text('+'),
          ),
        ],
      ),
    );
  }
}
