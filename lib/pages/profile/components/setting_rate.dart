import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../const.dart';
import '../../../main.dart';

class RateApp extends StatelessWidget {
  final String? version;
  const RateApp({required this.version, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("print");
      },
      child: Container(
        height: 68,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          boxShadow: [
            MyApp.of(context).isDarkMode()
                ? const BoxShadow(
                    color: Colors.transparent,
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 4), // changes position of shadow
                  )
                : BoxShadow(
                    color: MyApp.of(context).isDarkMode()
                        ? darkNeutral900.withOpacity(0.2)
                        : lightNeutral850.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 16,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
          ],
          color:
              MyApp.of(context).isDarkMode() ? darkNeutral50 : lightNeutral50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
            const SizedBox(width: 16),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Simply Timer",
                    style: body2Bold(context),
                  ),
                  Text("V.${version ?? ''}", style: body2(context)),
                ]),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 6.0, bottom: 6.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.profile_rate_us,
                style: body2Bold(context).copyWith(
                  color: MyApp.of(context).isDarkMode()
                      ? darkNeutral50
                      : lightNeutral50,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
