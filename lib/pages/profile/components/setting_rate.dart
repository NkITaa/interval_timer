import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../const.dart';
import '../../../main.dart';
import 'package:url_launcher/url_launcher.dart';

class RateApp extends StatelessWidget {
  final String? version;
  RateApp({required this.version, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!await launchUrl(Uri.parse('https://flutter.dev'))) {
          throw Exception('Could not launch');
        }
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
                    offset: Offset(0, 0), // changes position of shadow
                  )
                : BoxShadow(
                    color: const Color(0xff1D1D1D).withOpacity(0.16),
                    spreadRadius: 0,
                    blurRadius: 24,
                    offset: const Offset(0, 6), // changes position of shadow
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
              onPressed: () async {
                if (!await launchUrl(Uri.parse('https://flutter.dev'))) {
                  throw Exception('Could not launch');
                }
              },
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
