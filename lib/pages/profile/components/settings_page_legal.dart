import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:interval_timer/const.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPageLegal extends StatelessWidget {
  Future<String> data;

  SettingsPageLegal({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: data,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Markdown(
            onTapLink: (text, href, title) async {
              if (href != null && !await launchUrl(Uri.parse(href))) {
                throw Exception('Could not launch');
              }
            },
            data: snapshot.data!,
            styleSheet: MarkdownStyleSheet(
              p: body1(context),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
