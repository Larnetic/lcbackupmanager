import "package:fluent_ui/fluent_ui.dart";
import "package:get/get.dart";
import "package:lcbackupmanager/controller/backup_controller.dart";
import "package:lcbackupmanager/controller/settings_controller.dart";
import "package:lcbackupmanager/pages/root_navigator_page.dart";
import "package:window_manager/window_manager.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    title: "LC Backup Manager",
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  Get.put<SettingsController>(SettingsController());
  Get.put<BackupController>(BackupController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: "Lethal Company Bakup Manager",
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: FluentThemeData.dark(),
      home: const RootNavigatorPage(),
    );
  }
}
