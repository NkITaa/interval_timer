import 'dart:io';

import 'package:flutter/material.dart';
import 'package:interval_timer/l10n/app_localizations.dart';
import '../../../const.dart';
import 'package:url_launcher/url_launcher.dart';

class RateApp extends StatelessWidget {
  final String? version;
  const RateApp({required this.version, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {
        await launchUrl(
          Uri.parse(Platform.isAndroid
              ? 'https://play.google.com/store/apps/details?id=com.nikita.interval_timer'
              : 'https://apps.apple.com/app/id6475160260'),
          mode: LaunchMode.externalApplication,
        );
      },
      child: Container(
        height: 68,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          boxShadow: [
            Theme.of(context).brightness == Brightness.dark
                ? const BoxShadow(
                    color: Colors.transparent,
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 0), // changes position of shadow
                  )
                : BoxShadow(
                    color: const Color(0xff1D1D1D).withValues(alpha: 0.16),
                    spreadRadius: 0,
                    blurRadius: 24,
                    offset: const Offset(0, 6), // changes position of shadow
                  ),
          ],
          color: context.colors.neutral50,
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
            const SizedBox(width: 12),
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
                await launchUrl(
                  Uri.parse('https://apps.apple.com/app/id6475160260'),
                  mode: LaunchMode.externalApplication,
                );
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
                  color: context.colors.neutral50,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
