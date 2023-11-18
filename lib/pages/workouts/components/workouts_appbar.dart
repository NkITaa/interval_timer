import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:interval_timer/components/dialogs.dart';

class WorkoutsAppbar extends StatelessWidget implements PreferredSizeWidget {
  const WorkoutsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.title_workouts),
      actions: [
        IconButton(
          icon: const Icon(TablerIcons.circle_plus),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) =>
                  Dialogs.buildAddWorkoutDialog(context),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
