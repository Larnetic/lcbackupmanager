import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:lcbackupmanager/controller/backup_controller.dart';
import 'package:lcbackupmanager/pages/about_page.dart';
import 'package:lcbackupmanager/pages/backups_page.dart';
import 'package:lcbackupmanager/pages/settings_page.dart';

class RootNavigatorPage extends StatefulWidget {
  const RootNavigatorPage({super.key});

  @override
  State<RootNavigatorPage> createState() => _RootNavigatorPageState();
}

class _RootNavigatorPageState extends State<RootNavigatorPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        displayMode: PaneDisplayMode.open,
        size: const NavigationPaneSize(openWidth: 280.0),
        header: const SizedBox(
          height: 60,
          child: Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Lethal Company Backups",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        selected: _selectedIndex,
        onChanged: (index) => setState(() => _selectedIndex = index),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.cloud),
            title: const Text("Backups"),
            infoBadge: Obx(
              () => InfoBadge(
                source: Text(
                  Get.find<BackupController>().backupEntries.length.toString(),
                  style: TextStyle(color: context.theme.colorScheme.onPrimary),
                ),
              ),
            ),
            body: const BackupsPage(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text("Settings"),
            body: const SettingsPage(),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.info),
            title: const Text("About"),
            body: const AboutPage(),
          ),
        ],
      ),
    );
  }
}
