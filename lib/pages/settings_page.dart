import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:lcbackupmanager/controller/settings_controller.dart';

class SettingsPage extends GetWidget<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                InfoLabel(
                  label: "Backup Folder",
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => TextBox(
                            controller: TextEditingController(
                              text: controller.getBackupDirectory() != ""
                                  ? controller.getBackupDirectory()
                                  : "Could not auto-detect",
                            ),
                            enabled: false,
                            style: controller.getBackupDirectory() != ""
                                ? null
                                : TextStyle(color: context.theme.colorScheme.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Button(
                        onPressed: () async {
                          String? result = await FilePicker.platform.getDirectoryPath();
                          if (result != null) {
                            controller.setBackupDirectory(result);
                          }
                        },
                        style: ButtonStyle(
                          shape: ButtonState.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          ),
                          padding: ButtonState.all(
                            const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                          ),
                        ),
                        child: const Text("Browse"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                InfoLabel(
                  label: "Game Saves Folder",
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => TextBox(
                            controller: TextEditingController(
                              text: controller.getSaveGameDirectory() != ""
                                  ? controller.getSaveGameDirectory()
                                  : "Could not auto-detect",
                            ),
                            enabled: false,
                            style: controller.getSaveGameDirectory() != ""
                                ? null
                                : TextStyle(color: context.theme.colorScheme.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Button(
                        onPressed: () async {
                          String? result = await FilePicker.platform.getDirectoryPath();
                          if (result != null) {
                            controller.setSaveGameDirectory(result);
                          }
                        },
                        style: ButtonStyle(
                          shape: ButtonState.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          ),
                          padding: ButtonState.all(
                            const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                          ),
                        ),
                        child: const Text("Browse"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
