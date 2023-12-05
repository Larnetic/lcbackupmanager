import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:lcbackupmanager/models/backup_entry.dart';

class BackupEntryWidget extends StatelessWidget {
  BackupEntryWidget({super.key, required this.backupEntry});

  final BackupEntry backupEntry;
  final FlyoutController restoreController = FlyoutController();
  final FlyoutController deleteController = FlyoutController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: FlyoutTarget(
              controller: restoreController,
              child: FilledButton(
                child: const Text("Restore"),
                onPressed: () {
                  restoreController.showFlyout(
                    barrierDismissible: true,
                    dismissWithEsc: true,
                    autoModeConfiguration: FlyoutAutoConfiguration(
                      preferredMode: FlyoutPlacementMode.topCenter,
                    ),
                    builder: (context) {
                      return FlyoutContent(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "The current save game will be overwritten! Are you sure?",
                              ),
                              const SizedBox(height: 12.0),
                              Button(
                                child: const Text("Yes, I am sure"),
                                onPressed: () async {
                                  Flyout.of(context).close();
                                  await backupEntry.restore();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: FlyoutTarget(
              controller: deleteController,
              child: IconButton(
                style: ButtonStyle(
                  shape: ButtonState.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                  ),
                  padding: ButtonState.all(const EdgeInsets.all(12.0)),
                ),
                onPressed: () {
                  restoreController.showFlyout(
                    barrierDismissible: true,
                    dismissWithEsc: true,
                    autoModeConfiguration: FlyoutAutoConfiguration(
                      preferredMode: FlyoutPlacementMode.topCenter,
                    ),
                    builder: (context) {
                      return FlyoutContent(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "The current backup will be deleted! Are you sure?",
                              ),
                              const SizedBox(height: 12.0),
                              FilledButton(
                                style: ButtonStyle(
                                  backgroundColor: ButtonState.all(Colors.red),
                                ),
                                child: const Text(
                                  "Yes, I am sure",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  Flyout.of(context).close();
                                  await backupEntry.delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(FluentIcons.delete),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3.0, left: 2.0),
                child: Text(
                  backupEntry.name.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0, left: 2.0),
                child: Text(
                  "Save File: ${backupEntry.saveFile}",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[100]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0, left: 2.0),
                child: Text(
                  "Days: ${backupEntry.days}",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[100]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0, left: 2.0),
                child: Text(
                  "Money: ${backupEntry.money}",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[100]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0, left: 2.0),
                child: Text(
                  "Quota: ${backupEntry.quota}",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[100]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0, left: 2.0),
                child: Text(
                  "Player Count: ${backupEntry.playerCount}",
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[100]),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Text(
              DateFormat("dd.MM.yyyy HH:mm").format(backupEntry.timestamp),
              style: TextStyle(fontSize: 12.0, color: Colors.grey[80]),
            ),
          ),
        ],
      ),
    );
  }
}
