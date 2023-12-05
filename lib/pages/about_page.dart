import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/app_icon.png",
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Lethal Company Backup Manager",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // package version info and developer info
                Row(
                  children: [
                    Text(
                      "Version 1.0.0",
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[100]),
                    ),
                    const SizedBox(width: 8.0),
                    Button(
                      onPressed: () {
                        mat.showLicensePage(
                          context: context,
                          applicationIcon: Image.asset("assets/images/app_icon.png"),
                          applicationName: "Lethal Company Backup Manager",
                          applicationVersion: "1.0.0",
                          applicationLegalese: "© Larnetic (lrsvmb)",
                        );
                      },
                      style: ButtonStyle(
                        shape: ButtonState.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                        ),
                        padding: ButtonState.all(const EdgeInsets.all(10.0)),
                      ),
                      child: const Icon(FluentIcons.info12),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  "This application allows you to create and manage backups for the game Lethal Company.",
                  style: TextStyle(fontSize: 14.0, color: Colors.grey[100]),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      "\u00A9 Larnetic (lrsvmb)",
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[100]),
                    ),
                    const SizedBox(width: 8.0),
                    Button(
                      child: const Row(
                        children: [
                          Icon(LineIcons.github),
                          SizedBox(width: 8.0),
                          Text("GitHub"),
                        ],
                      ),
                      onPressed: () {
                        openGitHub();
                      },
                    ),
                  ],
                ),
                Text(
                  "This application is not affiliated with Lethal Company or ZeekerssRBLX in any way.",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[100]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Opens the GitHub repository for the lcbackupmanager project.
  /// If the URL can be launched, it opens the repository in the default browser.
  void openGitHub() async {
    if (await canLaunchUrlString("https://github.com/lrsvmb/lcbackupmanager")) {
      await launchUrlString("https://github.com/lrsvmb/lcbackupmanager");
    }
  }
}
