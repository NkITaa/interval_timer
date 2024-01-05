import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/components/dialogs.dart';
import 'package:interval_timer/const.dart';

import '../../../main.dart';

class WorkoutsAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Function setListState;

  const WorkoutsAppbar({super.key, required this.setListState});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(AppLocalizations.of(context)!.title_workouts,
              style: heading3Bold(context)),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                TablerIcons.circle_plus,
                color: MyApp.of(context).isDarkMode()
                    ? darkNeutral850
                    : lightNeutral700,
              ),
              onPressed: () {
                TextEditingController nameController = TextEditingController();
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  enableDrag: false,
                  context: context,
                  builder: (BuildContext context) =>
                      Dialogs.buildAddWorkoutDialog(
                          context, setListState, nameController),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
