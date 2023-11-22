import 'package:flutter/material.dart';
import 'package:interval_timer/const.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.dialog_required_field;
              }
              return null;
            },
            onTapOutside: (PointerDownEvent event) {
              FocusScope.of(context).unfocus();
            },
            cursorColor: lightNeutral300,
            controller: nameController,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: lightNeutral300),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: lightNeutral300),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
