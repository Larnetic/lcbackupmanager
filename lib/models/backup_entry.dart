import 'dart:io';
import 'package:lcbackupmanager/controller/backup_controller.dart';
import 'package:path/path.dart' as p;

import 'package:get/get.dart';
import 'package:lcbackupmanager/controller/settings_controller.dart';
import 'package:uuid/uuid.dart';

class BackupEntry {
  final String id;
  final String name;
  final String relativePath;
  final DateTime timestamp;
  final int days;
  final int money;
  final int quota;
  final int saveFile;
  final int playerCount;

  BackupEntry({
    required this.name,
    required this.relativePath,
    required this.timestamp,
    required this.days,
    required this.money,
    required this.quota,
    required this.playerCount,
    required this.saveFile,
  }) : id = const Uuid().v4();

  factory BackupEntry.fromJson(Map<String, dynamic> json) {
    return BackupEntry(
      name: json['name'],
      relativePath: json['relativePath'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      days: json['days'],
      money: json['money'],
      quota: json['quota'],
      saveFile: json['saveFile'],
      playerCount: json['playerCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'relativePath': relativePath,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'days': days,
        'money': money,
        'quota': quota,
        'playerCount': playerCount,
        'saveFile': saveFile,
      };

  Future restore() async {
    // copy save file from backup dir to game dir
    File(
      p.join(
        Get.find<SettingsController>().getBackupDirectory(),
        relativePath,
        "LCSaveFile$saveFile",
      ),
    ).copySync(
      p.join(
        Get.find<SettingsController>().getSaveGameDirectory(),
        "LCSaveFile$saveFile",
      ),
    );
  }

  Future delete() async {
    Directory(
      p.join(
        Get.find<SettingsController>().getBackupDirectory(),
        relativePath,
      ),
    ).deleteSync(recursive: true);
    Get.find<BackupController>().deleteBackupEntry(this);
  }

  @override
  String toString() {
    return 'BackupEntry(name: $name, relativePath: $relativePath, timestamp: $timestamp, days: $days, money: $money, quota: $quota, playerCount: $playerCount, saveFile: $saveFile)';
  }
}
