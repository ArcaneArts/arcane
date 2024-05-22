import 'package:arcane/arcane.dart';

class FirebaseService extends StatelessService implements AsyncStartupTasked {
  late FirebaseApp app;

  @override
  Future<void> onStartupTask() async {
    app = await Firebase.initializeApp(options: Arcane.app.firebase);
    success("Firebase Initialized: ${app.name} (${app.options.projectId})");
  }
}
