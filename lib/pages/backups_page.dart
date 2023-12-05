import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lcbackupmanager/controller/backup_controller.dart';
import 'package:lcbackupmanager/controller/settings_controller.dart';
import 'package:lcbackupmanager/widgets/backup_entry_widget.dart';

class BackupsPage extends GetWidget<BackupController> {
  const BackupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Backups",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    createBackupFromDialog(context);
                  },
                  style: ButtonStyle(
                    shape: ButtonState.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                    ),
                    padding: ButtonState.all(
                      const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    ),
                  ),
                  child: const Text("Create Backup"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 300,
                  mainAxisExtent: 180,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: controller.backupEntries.length,
                itemBuilder: (BuildContext context, int index) {
                  return BackupEntryWidget(backupEntry: controller.backupEntries[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void createBackupFromDialog(BuildContext context) async {
    int money = 0;
    int quota = 0;
    int days = 0;
    int saveFile = 1;
    int playerCount = 1;
    TextEditingController nameController = TextEditingController(
      text: "New backup ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
    );
    final formKey = GlobalKey<FormState>();
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ContentDialog(
          constraints: const BoxConstraints(maxWidth: 550),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InfoLabel(
                label: "Name",
                child: Form(
                  key: formKey,
                  child: TextFormBox(
                    maxLines: 1,
                    onTap: () {
                      nameController.clear();
                    },
                    controller: nameController,
                    validator: (value) {
                      if (value == "") {
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                    errorHighlightColor: context.theme.colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: InfoLabel(
                      label: "Money",
                      child: NumberBox(
                        value: money,
                        onChanged: (value) {
                          money = value!;
                        },
                        min: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: InfoLabel(
                      label: "Quota",
                      child: NumberBox(
                        value: quota,
                        onChanged: (value) {
                          quota = value!;
                        },
                        min: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: InfoLabel(
                      label: "Days",
                      child: NumberBox(
                        value: days,
                        onChanged: (value) {
                          days = value!;
                        },
                        min: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: InfoLabel(
                      label: "Players",
                      child: NumberBox(
                        value: playerCount,
                        onChanged: (value) {
                          playerCount = value!;
                        },
                        min: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: InfoLabel(
                      label: "Save File",
                      child: SizedBox(
                        width: double.infinity,
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            if (Get.find<SettingsController>().saveFileCount.value == 0) {
                              return TextBox(
                                enabled: false,
                                controller: TextEditingController(text: "No save files found"),
                                style: TextStyle(
                                  color: context.theme.colorScheme.error,
                                ),
                              );
                            } else {
                              return SizedBox(
                                width: 50,
                                child: ComboBox<int>(
                                  value: saveFile,
                                  onChanged: (value) {
                                    setState(() {
                                      saveFile = value!;
                                    });
                                  },
                                  items: [
                                    for (int i = 1;
                                        i <= Get.find<SettingsController>().saveFileCount.value;
                                        i++)
                                      ComboBoxItem(
                                        value: i,
                                        child: Text("Save File $i"),
                                      ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              InfoLabel(
                label: "Backup Path",
                child: TextBox(
                  enabled: false,
                  controller: TextEditingController(
                    text: Get.find<SettingsController>().isBackupDirectorySet()
                        ? Get.find<SettingsController>().getBackupDirectory()
                        : "Could not auto-detect",
                  ),
                  style: TextStyle(
                    color: Get.find<SettingsController>().isBackupDirectorySet()
                        ? null
                        : context.theme.colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              InfoLabel(
                label: "Game Path",
                child: TextBox(
                  enabled: false,
                  controller: TextEditingController(
                    text: Get.find<SettingsController>().isSaveGameDirectorySet()
                        ? Get.find<SettingsController>().getSaveGameDirectory()
                        : "Could not auto-detect",
                  ),
                  style: TextStyle(
                    color: Get.find<SettingsController>().isSaveGameDirectorySet()
                        ? null
                        : context.theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Button(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            Obx(
              () => FilledButton(
                onPressed: shouldAllowBackup()
                    ? () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context, true);
                        }
                      }
                    : null,
                child: const Text("Create"),
              ),
            ),
          ],
        );
      },
    );
    if (result == null || !result) {
      return;
    }
    Get.find<BackupController>().createBackupEntry(
      nameController.text,
      days,
      money,
      quota,
      playerCount,
      saveFile,
    );
  }

  bool shouldAllowBackup() {
    return Get.find<SettingsController>().isBackupDirectorySet() &&
        Get.find<SettingsController>().isSaveGameDirectorySet() &&
        Get.find<SettingsController>().hasSaveFiles();
  }
}
