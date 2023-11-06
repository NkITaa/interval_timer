import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncrementDecrementButton extends StatefulWidget {
  final String type;
  const IncrementDecrementButton({super.key, required this.type});

  @override
  State<IncrementDecrementButton> createState() =>
      _IncrementDecrementButtonState();
}

class _IncrementDecrementButtonState extends State<IncrementDecrementButton> {
  late DateTime? minutes;
  late int? sets;

  @override
  void initState() {
    super.initState();
    if (widget.type == "training") {
      minutes = DateTime(0, 0, 0, 0, 1, 15);
    } else if (widget.type == "pause") {
      minutes = DateTime(0, 0, 0, 0, 0, 15);
    } else if (widget.type == "set") {
      sets = 3;
    }
  }

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
                if (widget.type != "set") {
                  minutes = minutes!.subtract(const Duration(seconds: 15));
                } else {
                  sets = sets! - 1;
                }
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
                  child: Text(widget.type != "set"
                      ? DateFormat('mm:ss').format(minutes!)
                      : sets.toString()),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (widget.type != "set") {
                  minutes = minutes!.add(const Duration(seconds: 15));
                } else {
                  sets = sets! + 1;
                }
              });
            },
            child: const Text('+'),
          ),
        ],
      ),
    );
  }
}
