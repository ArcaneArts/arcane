import 'dart:convert';
import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:arcane/feature/service/logging_service.dart';
import 'package:arcane/feature/service/user_service.dart';
import 'package:crypto/crypto.dart';
import 'package:dialoger/dialoger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginService extends StatelessService {
  bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  Future<void> signOut() => Future.wait([
        svc<UserService>().unbind(),
        FirebaseAuth.instance.signOut(),
        GoogleSignIn.standard().signOut()
      ]);

  Future<void> signOutDialog() => dialogConfirm(
      context: Arcane.context,
      title: "Log Out?",
      description:
          "Are you sure you want to log out of your account? You will need to log in again before you can use Crucible again.",
      confirmButtonText: "Log Out",
      onConfirm: (context) => signOut().then((value) =>
          Navigator.pushNamedAndRemoveUntil(
              context, "/splash", (route) => false)));

  String? extractFirstName(User user) {
    List<String> dns = getPotentialExtractionNames(user);

    if (dns.isNotEmpty) {
      return dns.first.contains(" ") ? dns.first.split(" ").first : dns.first;
    }

    return null;
  }

  List<String> getPotentialExtractionNames(User user) {
    List<String> dns = user.providerData
        .where((element) => element.displayName != null)
        .map((e) => e.displayName!)
        .toList();
    if (user.displayName != null) {
      dns.add(user.displayName!);
    }

    success(
        "Extracted ${dns.length} display names from user: ${dns.join(",")}");
    return dns;
  }

  String? extractLastName(User user) {
    List<String> dns = getPotentialExtractionNames(user);

    if (dns.isNotEmpty) {
      return dns.first.contains(" ")
          ? dns.first.split(" ").sublist(1).join(" ")
          : dns.first;
    }

    return null;
  }

  Future<UserCredential> signInWithApple() async {
    late UserCredential c;
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    c = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    Map<String, dynamic> profile = c.additionalUserInfo?.profile ?? {};
    String? firstName = appleCredential.givenName ??
        profile["given_name"] ??
        extractFirstName(c.user!);
    String? lastName = appleCredential.familyName ??
        profile["family_name"] ??
        extractLastName(c.user!);
    verbose("Apple First Name: $firstName");
    verbose("Apple Last Name: $lastName");
    svc<UserService>().grabName(firstName, lastName);

    return c;
  }

  Future<UserCredential> signInWithGoogle() async {
    late UserCredential c;

    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        c = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        GoogleSignInAccount? googleUser =
            await GoogleSignIn.standard().signIn();
        GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth == null) {
          error("Google Auth is null!");
        }

        OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        c = await FirebaseAuth.instance.signInWithCredential(credential);
      }
      Map<String, dynamic> profile = c.additionalUserInfo?.profile ?? {};
      String? firstName = profile["given_name"] ?? extractFirstName(c.user!);
      String? lastName = profile["family_name"] ?? extractLastName(c.user!);
      //String? profilePictureUrl = profile["picture"];

      verbose("Google First Name: $firstName");
      verbose("Google Last Name: $lastName");
      svc<UserService>().grabName(firstName, lastName);
    } catch (e, es) {
      talker.handle(e, es, "Google Sign In Failed!");
    }
    return c;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
