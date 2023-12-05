import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  // the path to the current backup folder
  RxString backupDirectory = "".obs;

  // the path to the current game folder
  RxString saveGameDirectory = "".obs;

  // current fond save file count
  RxInt saveFileCount = 0.obs;

  // function to store all attributes using shared preferences
  Future storeAttributes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("backupDirectory", backupDirectory.value);
    await prefs.setString("saveGameDirectory", saveGameDirectory.value);
  }

  Future loadDirectories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    backupDirectory.value = prefs.getString("backupDirectory") ?? "";
    saveGameDirectory.value = prefs.getString("saveGameDirectory") ?? "";

    // standard save game location
    if (saveGameDirectory.value.isEmpty) {
      String appDataPath = p.dirname(Platform.environment["APPDATA"]!);
      String saveGamePath = p.joinAll([appDataPath, "LocalLow", "ZeekerssRBLX", "Lethal Company"]);
      if (Directory(saveGamePath).existsSync()) {
        saveGameDirectory.value = saveGamePath;
      }
    }

    // standard backup location
    if (backupDirectory.value.isEmpty) {
      Directory tempDir = await getApplicationSupportDirectory();
      if (tempDir.existsSync()) {
        backupDirectory.value = p.join(tempDir.path, "backups");
      }
    }
    // create backup directory if it does not exist
    Directory(Get.find<SettingsController>().getBackupDirectory()).createSync();
  }

  Future getSaveFileCount() async {
    Directory saveGameDir = Directory(saveGameDirectory.value);
    if (saveGameDir.existsSync()) {
      int count = 0;
      for (FileSystemEntity entity in saveGameDir.listSync(recursive: true)) {
        if (entity is File) {
          if (p.basename(entity.path).contains("LCSaveFile")) {
            count++;
          }
        }
      }
      saveFileCount.value = count;
    }
  }

  void initializeApp() async {
    await loadDirectories();
    await getSaveFileCount();
  }

  // function to reset all attributes
  void resetAttributes() {
    backupDirectory.value = "";
    saveGameDirectory.value = "";
  }

  // function to set the backup path
  void setBackupDirectory(String path) {
    backupDirectory.value = path;
    storeAttributes();
  }

  // function to set the game path
  void setSaveGameDirectory(String path) {
    saveGameDirectory.value = path;
    storeAttributes();
  }

  // function to get the backup path
  String getBackupDirectory() {
    return backupDirectory.value;
  }

  // function to get the game path
  String getSaveGameDirectory() {
    return saveGameDirectory.value;
  }

  bool isBackupDirectorySet() {
    return backupDirectory.value.isNotEmpty;
  }

  bool isSaveGameDirectorySet() {
    return saveGameDirectory.value.isNotEmpty;
  }

  bool hasSaveFiles() {
    return saveFileCount.value > 0;
  }

  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }
}
