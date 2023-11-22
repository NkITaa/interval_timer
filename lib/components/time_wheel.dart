import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:scroll_snap_list/scroll_snap_list.dart';

class TimeWheel extends StatelessWidget {
  final List<int> data = List.generate(60, (index) => index);
  final Function(String type, int newValue, bool? minute) setValue;
  final Function(String type, int newValue, bool? minute) setValueLocal;

  final String type;
  final int value;
  final bool? minute;
  TimeWheel(
      {super.key,
      required this.setValue,
      required this.type,
      required this.setValueLocal,
      this.minute,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 224,
      child: Stack(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Divider(color: Colors.black, thickness: 3),
              SizedBox(height: 50),
              Divider(color: Colors.black, thickness: 3),
            ],
          ),
          ScrollSnapList(
            onItemFocus: (int index) {
              setValueLocal(type, index, minute);
              setValue(type, index, minute);
            },
            itemSize: 76,
            dynamicItemOpacity: 0.3,
            itemBuilder: (BuildContext context, int index) => Container(
              height: 76,
              alignment: Alignment.center,
              child: Text(
                index.toString(),
                style: const TextStyle(fontSize: 32),
              ),
            ),
            initialIndex: value.toDouble(),
            itemCount: data.length,
            focusOnItemTap: true,
            scrollDirection: Axis.vertical,
          ),
        ],
      ),
    );
  }
}
