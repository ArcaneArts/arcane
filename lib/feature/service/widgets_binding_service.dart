import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:serviced/serviced.dart';

class WidgetsBindingService extends Service {
  late WidgetsBinding binding;

  @override
  void onStart() {
    binding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: binding);
  }

  void dropSplash() {
    FlutterNativeSplash.remove();
  }

  @override
  void onStop() {}
}
