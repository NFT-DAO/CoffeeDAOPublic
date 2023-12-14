import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamMemberWidget extends StatelessWidget {
  final Map data;
  const TeamMemberWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> launchInBrowser() async {
      if (data['linkedinLink'] != null) {
        if (!await launchUrl(
          Uri.parse(data['linkedinLink'] as String),
          mode: LaunchMode.externalApplication,
        )) {
          throw 'Could not launch ${data['linkedinLink']}';
        }
      }
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 100.0,
          backgroundImage: NetworkImage(data['avatarURL']),
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(
          height: 12,
        ),
        Text(data['name'], textAlign: TextAlign.center),
        Text(data['title'], textAlign: TextAlign.center),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
            width: 200,
            child:
                Text('''${data['descriptor']}''', textAlign: TextAlign.center)),
        data['linkedinLink'] != null
            ? TextButton(
                onPressed: () => launchInBrowser(),
                child: Text(
                  data['linkedinLink'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ))
            : const SizedBox(height: 0)
      ],
    );
  }
}
