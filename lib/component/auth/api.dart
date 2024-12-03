abstract class ArcaneAuthProvider {
  Future<void> signInWithProvider(ArcaneSignInProviderType type);

  Future<void> signInWithEmailPassword(
      {required String email, required String password});

  Future<void> registerWithEmailPassword(
      {required String email, required String password});
}

enum ArcaneSignInProviderType {
  google,
  apple
}