import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:serviced/serviced.dart';

class WidgetsBindingService extends Service {
  late WidgetsBinding binding;
  bool dropped = false;

  @override
  void onStart() {
    binding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: binding);
  }

  void dropSplash() {
    FlutterNativeSplash.remove();
    dropped = true;
  }

  void dropIfUp() {
    if (!dropped) {
      dropSplash();
    }
  }

  @override
  void onStop() {}
}
