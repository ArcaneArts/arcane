import 'package:arcane/arcane.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService extends StatelessService implements AsyncStartupTasked {
  late FirebaseApp app;

  @override
  Future<void> onStartupTask() async {
    app = await Firebase.initializeApp(options: Arcane.app.firebase);

    FirebaseAuth.instance.authStateChanges().listen((u) {
      verbose("Auth State: User state changed: ${u?.uid}");

      if (Arcane.isWindowManaged && u != null) {
        //     FirebaseAuth.instance.signOut();
      }
    });
    success("Firebase Initialized: ${app.name} (${app.options.projectId})");
  }
}
