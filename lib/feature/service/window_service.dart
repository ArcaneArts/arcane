import 'package:arcane/arcane.dart';
import 'package:window_manager/window_manager.dart';

class WindowService extends StatelessService implements AsyncStartupTasked {
  @override
  Future<void> onStartupTask() async {
    if (!Arcane.isWindowManaged) {
      return;
    }

    await windowManager.ensureInitialized();
    WindowOptions awo = Arcane.app.windowOptions;
    WindowOptions windowOptions = WindowOptions(
      size: awo.size,
      center: awo.center,
      backgroundColor: awo.backgroundColor,
      alwaysOnTop: awo.alwaysOnTop,
      fullScreen: awo.fullScreen,
      maximumSize: awo.maximumSize,
      minimumSize: awo.minimumSize,
      windowButtonVisibility: awo.windowButtonVisibility,
      skipTaskbar: awo.skipTaskbar,
      titleBarStyle: awo.titleBarStyle,
      title: Arcane.app.title,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      showWindow();
      Arcane.app.events?.onWindowManagerShown?.call();
    });
  }

  Future<void> showWindow() async {
    if (!await windowManager.isVisible()) {
      await windowManager.show();
    }

    await windowManager.focus();
  }

  Future<void> hideWindow() async {
    if (Arcane.app.exitWindowOnClose) {
      await windowManager.close();
    } else {
      await windowManager.hide();
    }
  }

  Future<bool> get isMaximized => windowManager.isMaximized();

  void onUnMaximize() => windowManager.unmaximize();

  void onMaximize() => windowManager.maximize();

  void onStartDragging() => windowManager.startDragging();

  void onClose() => hideWindow();
}
