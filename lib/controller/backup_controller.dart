import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:lcbackupmanager/controller/settings_controller.dart';
import 'package:lcbackupmanager/models/backup_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class BackupController extends GetxController {
  // list of all backup entries
  final RxList<BackupEntry> backupEntries = <BackupEntry>[].obs;

  // create backup entry from attributes
  void createBackupEntry(
    String name,
    int days,
    int money,
    int quota,
    int playerCount,
    int saveFile,
  ) async {
    DateTime now = DateTime.now();
    BackupEntry entry = BackupEntry(
      name: name,
      relativePath: now.millisecondsSinceEpoch.toString(),
      timestamp: now,
      days: days,
      money: money,
      quota: quota,
      playerCount: playerCount,
      saveFile: saveFile,
    );
    backupEntries.add(
      entry,
    );
    await storeBackupEntries();

    // create backup folder
    Directory(
      p.join(Get.find<SettingsController>().getBackupDirectory(), entry.relativePath),
    ).createSync();

    // copy one save file called "LCSaveFile${saveFile}" into backup dir
    File(
      p.join(
        Get.find<SettingsController>().getSaveGameDirectory(),
        "LCSaveFile$saveFile",
      ),
    ).copySync(
      p.join(
        Get.find<SettingsController>().getBackupDirectory(),
        entry.relativePath,
        "LCSaveFile$saveFile",
      ),
    );
  }

  // delete backup entry
  void deleteBackupEntry(BackupEntry backupEntry) async {
    backupEntries.remove(backupEntry);
    await storeBackupEntries();
  }

  // store all backup entries in shared preferences
  Future storeBackupEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      "backupEntries",
      backupEntries.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  // load all backup entries from shared preferences
  void loadBackupEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> backupEntriesJson = prefs.getStringList("backupEntries") ?? [];
    backupEntries.clear();
    for (var element in backupEntriesJson) {
      backupEntries.add(BackupEntry.fromJson(jsonDecode(element)));
    }
  }

  // reset all backup entries
  void resetBackupEntries() {
    backupEntries.clear();
  }

  // get all backup entries
  List<BackupEntry> getBackupEntries() {
    return backupEntries;
  }

  @override
  void onInit() {
    super.onInit();
    loadBackupEntries();
  }
}
