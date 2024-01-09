import 'package:flutter/material.dart';
import 'package:interval_timer/const.dart';
import 'package:interval_timer/main.dart';
// ignore: depend_on_referenced_packages
import 'package:scroll_snap_list/scroll_snap_list.dart';

class TimeWheel extends StatelessWidget {
  final Function(String type, int newValue, bool? minute) setValue;
  final Function(String type, int newValue, bool? minute) setValueLocal;

  final String type;
  final int value;
  final bool? minute;
  final int? otherValue;
  TimeWheel(
      {super.key,
      required this.setValue,
      required this.type,
      required this.setValueLocal,
      this.otherValue,
      this.minute,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 224,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Divider(
                  color: MyApp.of(context).isDarkMode()
                      ? darkNeutral850
                      : lightNeutral850,
                  thickness: 3),
              const SizedBox(height: 50),
              Divider(
                  color: MyApp.of(context).isDarkMode()
                      ? darkNeutral850
                      : lightNeutral850,
                  thickness: 3),
            ],
          ),
          ScrollSnapList(
            onItemFocus: (int index) {
              if (index == 0 && type == 'training' && otherValue == 0) {
                return;
              } else {
                setValueLocal(type, index, minute);

                if (type == 'set') {
                  setValue(type, index + 1, minute);
                } else {
                  setValue(type, index, minute);
                }
              }
            },
            itemSize: 76,
            dynamicItemOpacity: 0.3,
            itemBuilder: (BuildContext context, int index) => Container(
              height: 76,
              alignment: Alignment.center,
              child: Text(
                type == 'set' ? (index + 1).toString() : index.toString(),
                style: heading3Bold(context).copyWith(fontSize: 32),
              ),
            ),
            initialIndex:
                type == 'set' ? value.toDouble() - 1 : value.toDouble(),
            itemCount: 60,
            focusOnItemTap: true,
            scrollDirection: Axis.vertical,
          ),
        ],
      ),
    );
  }
}
