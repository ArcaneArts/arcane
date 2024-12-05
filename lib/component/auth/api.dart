import 'package:arcane/generated/arcane_shadcn/shadcn_flutter.dart';

abstract class ArcaneAuthProvider {
  Future<void> signInWithProvider(
      BuildContext context, ArcaneSignInProviderType type);

  Future<void> signInWithEmailPassword(
      {required String email, required String password});

  Future<void> registerWithEmailPassword(
      {required String email, required String password});
}

enum ArcaneSignInProviderType { google, apple, microsoft, facebook }
