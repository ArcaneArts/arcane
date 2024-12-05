import 'package:arcane/arcane.dart' hide EmailValidator;
import 'package:email_validator/email_validator.dart';
import 'package:fast_log/fast_log.dart';

class LoginScreen extends StatefulWidget {
  final Widget header;
  final bool allowEmailPassword;
  final List<Widget> loginButtons;
  final ArcanePasswordPolicy passwordPolicy;
  final bool allowViewPassword;

  const LoginScreen(
      {super.key,
      this.passwordPolicy = const ArcanePasswordPolicy(),
      this.allowEmailPassword = true,
      this.allowViewPassword = true,
      required this.loginButtons,
      this.header = const SizedBox.shrink()});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) => FillScreen(
      gutter: false,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          widget.header,
          Gap(16),
          if (widget.allowEmailPassword)
            ArcaneEmailPasswordCard(
              loading: (l) => setState(() {
                loading = l;
              }),
              passwordPolicy: widget.passwordPolicy,
            ),
          Gap(16),
          loading
              ? SizedBox.shrink()
              : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.loginButtons,
                ),
          Spacer(),
        ],
      )));
}

class ArcanePasswordPolicy {
  final int minPasswordLength;
  final int maxPasswordLength;
  final bool requireUppercaseLetter;
  final bool requireLowercaseLetter;
  final bool requireSpecialCharacter;
  final bool requireNumericCharacter;

  const ArcanePasswordPolicy(
      {this.minPasswordLength = 6,
      this.maxPasswordLength = 4096,
      this.requireLowercaseLetter = false,
      this.requireUppercaseLetter = false,
      this.requireSpecialCharacter = false,
      this.requireNumericCharacter = false})
      : assert(minPasswordLength >= 6 && minPasswordLength <= 30,
            "Password must be at least 6 characters long and no more than 30 characters long as per firebase auth limits (see firebase auth settings in console)"),
        assert(maxPasswordLength >= 6 && maxPasswordLength <= 4096,
            "Password must be at least 6 characters long and no more than 30 characters long as per firebase auth limits (see firebase auth settings in console)");

  Iterable<String> validate(String password) sync* {
    if (password.trim().length != password.length) {
      yield "Password cannot contain leading or trailing whitespace";
    }

    if (password.length < minPasswordLength) {
      yield "Password must be at least ${minPasswordLength} characters long";
    }

    if (password.length > maxPasswordLength) {
      yield "Password must be no more than ${maxPasswordLength} characters long";
    }

    if (requireUppercaseLetter && !RegExp(r'[A-Z]').hasMatch(password)) {
      yield "Password must contain at least one uppercase letter";
    }

    if (requireLowercaseLetter && !RegExp(r'[a-z]').hasMatch(password)) {
      yield "Password must contain at least one lowercase letter";
    }

    if (requireSpecialCharacter &&
        !RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      yield "Password must contain at least one special character";
    }

    if (requireNumericCharacter && !RegExp(r'[0-9]').hasMatch(password)) {
      yield "Password must contain at least one numeric character";
    }
  }
}

class ArcaneEmailPasswordCard extends StatefulWidget {
  final ArcanePasswordPolicy passwordPolicy;
  final ValueChanged<bool> loading;

  const ArcaneEmailPasswordCard(
      {super.key,
      required this.loading,
      this.passwordPolicy = const ArcanePasswordPolicy()});

  @override
  State<ArcaneEmailPasswordCard> createState() =>
      _ArcaneEmailPasswordCardState();
}

class _ArcaneEmailPasswordCardState extends State<ArcaneEmailPasswordCard> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode passwordConfirmFocus = FocusNode();
  int index = 0;
  bool touchedEmail = false;
  bool touchedPassword = false;
  bool touchedPasswordConfirm = false;
  bool loading = false;
  bool revealingPassword = false;
  bool revealingPasswordConfirm = false;

  Iterable<String> validate({bool soft = false}) sync* {
    if (!isEmailValid && (touchedEmail || !soft)) {
      yield "Invalid email address";
    }

    if (index == 1) {
      if (!soft || touchedPassword) {
        yield* widget.passwordPolicy.validate(passwordController.text);
      }

      if (!soft || (touchedPasswordConfirm && touchedPassword)) {
        if (passwordController.text != passwordConfirmController.text) {
          yield "Passwords do not match";
        }
      }
    }
  }

  bool get isEmailValid => EmailValidator.validate(emailController.text);

  bool get isValidPassword => passwordController.text.length >= 6;

  bool get isValid =>
      validate().isEmpty &&
      (index == 0 || passwordController.text == passwordConfirmController.text);

  void _login() async {
    setState(() {
      loading = true;
    });
    widget.loading(loading);
    await Future.delayed(1.seconds);
    try {
      await context.pylon<ArcaneAuthProvider>().signInWithEmailPassword(
          email: emailController.text, password: passwordController.text);
    } catch (e) {
      error("Login Error $e");
      TextToast("Login Error $e").open(context);
    }
    passwordController.clear();
    passwordConfirmController.clear();
    setState(() {
      loading = false;
    });
    widget.loading(loading);
  }

  void _register() async {
    setState(() {
      loading = true;
    });
    widget.loading(loading);
    await Future.delayed(1.seconds);
    try {
      await context.pylon<ArcaneAuthProvider>().registerWithEmailPassword(
          email: emailController.text, password: passwordController.text);
    } catch (e) {
      error("Register Error $e");
      TextToast("Register Error $e").open(context);
    }
    passwordController.clear();
    passwordConfirmController.clear();
    setState(() {
      loading = false;
    });
    widget.loading(loading);
  }

  @override
  Widget build(BuildContext context) => Card(
        child: loading
            ? Center(
                child: Basic(
                  leadingAlignment: Alignment.centerLeft,
                  leading: CircularProgressIndicator(),
                  title: index == 0 ? Text("Logging In") : Text("Registering"),
                ).iw,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Tabs(
                      index: index,
                      onChanged: (g) => setState(() {
                            index = g;
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              emailFocus.requestFocus();
                              passwordConfirmController.clear();
                            });
                          }),
                      tabs: [Text("Log In"), Text("Register")]),
                  Gap(16),
                  AnimatedSize(
                    clipBehavior: Clip.none,
                    duration: 100.ms,
                    curve: Curves.decelerate,
                    child: IndexedStack(
                      clipBehavior: Clip.none,
                      sizing: StackFit.passthrough,
                      index: index,
                      children: [
                        Visibility(
                            visible: index == 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  focusNode: emailFocus,
                                  controller: emailController,
                                  autofillHints: [AutofillHints.email],
                                  placeholder: "Email",
                                  border: false,
                                  leading: Icon(Icons.mail_outline_ionic),
                                  onChanged: (_) => setState(() {}),
                                  onSubmitted: (s) {
                                    setState(() {
                                      touchedEmail = true;
                                    });
                                    passwordFocus.requestFocus();
                                  },
                                ),
                                Gap(4),
                                Divider(),
                                Gap(4),
                                TextField(
                                  focusNode: passwordFocus,
                                  controller: passwordController,
                                  autofillHints: [AutofillHints.password],
                                  placeholder: "Password",
                                  obscureText: !revealingPassword,
                                  border: false,
                                  trailing: GestureDetector(
                                    onTapDown: (_) => setState(() {
                                      revealingPassword = true;
                                    }),
                                    onTapUp: (_) => setState(() {
                                      revealingPassword = false;
                                    }),
                                    child: Icon(revealingPassword
                                        ? Icons.eye
                                        : Icons.eye_closed),
                                  ),
                                  leading: Icon(Icons.lock),
                                  onChanged: (_) => setState(() {
                                    touchedPassword = true;
                                  }),
                                  onSubmitted: (pass) => setState(() {
                                    touchedPassword = true;

                                    if (isValid) {
                                      _login();
                                    }
                                  }),
                                ),
                                if (validate().isNotEmpty) ...[
                                  Gap(8),
                                  ...validate(soft: true)
                                      .map((e) => PaddingHorizontal(
                                          padding: 8,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.warning_fill,
                                                size: 11,
                                                color: Colors.red,
                                              ).xSmall(),
                                              Gap(8),
                                              Text(e,
                                                      style: TextStyle(
                                                          color: Colors.red))
                                                  .xSmall()
                                            ],
                                          )))
                                ],
                                Gap(16),
                                PrimaryButton(
                                    child: Text("Log In"),
                                    onPressed: isValid ? () => _login() : null)
                              ],
                            )),
                        Visibility(
                            visible: index == 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  focusNode: emailFocus,
                                  controller: emailController,
                                  autofillHints: [AutofillHints.email],
                                  placeholder: "Email",
                                  border: false,
                                  onChanged: (_) => setState(() {}),
                                  leading: Icon(Icons.mail_outline_ionic),
                                  onSubmitted: (s) {
                                    setState(() {
                                      touchedEmail = true;
                                    });
                                    passwordFocus.requestFocus();
                                  },
                                ),
                                Gap(4),
                                Divider(),
                                Gap(4),
                                TextField(
                                  focusNode: passwordFocus,
                                  controller: passwordController,
                                  autofillHints: [AutofillHints.password],
                                  placeholder: "Password",
                                  trailing: GestureDetector(
                                    onTapDown: (_) => setState(() {
                                      revealingPassword = true;
                                    }),
                                    onTapUp: (_) => setState(() {
                                      revealingPassword = false;
                                    }),
                                    child: Icon(revealingPassword
                                        ? Icons.eye
                                        : Icons.eye_closed),
                                  ),
                                  obscureText: !revealingPassword,
                                  border: false,
                                  onChanged: (_) => setState(() {
                                    touchedPassword = true;
                                  }),
                                  leading: Icon(Icons.lock),
                                  onSubmitted: (pass) =>
                                      passwordConfirmFocus.requestFocus(),
                                ),
                                Gap(4),
                                TextField(
                                  focusNode: passwordConfirmFocus,
                                  controller: passwordConfirmController,
                                  autofillHints: [AutofillHints.password],
                                  placeholder: "Confirm Password",
                                  obscureText: !revealingPasswordConfirm,
                                  border: false,
                                  trailing: GestureDetector(
                                    onTapDown: (_) => setState(() {
                                      revealingPasswordConfirm = true;
                                    }),
                                    onTapUp: (_) => setState(() {
                                      revealingPasswordConfirm = false;
                                    }),
                                    child: Icon(revealingPasswordConfirm
                                        ? Icons.eye
                                        : Icons.eye_closed),
                                  ),
                                  onChanged: (_) => setState(() {
                                    touchedPasswordConfirm = true;
                                  }),
                                  leading: Icon(Icons.lock_key),
                                  onSubmitted: (pass) {
                                    setState(() {
                                      touchedPasswordConfirm = true;
                                    });
                                    if (isValid) {
                                      _register();
                                    }
                                  },
                                ),
                                if (validate().isNotEmpty) ...[
                                  Gap(8),
                                  ...validate(soft: true)
                                      .map((e) => PaddingHorizontal(
                                          padding: 8,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.warning_fill,
                                                size: 11,
                                                color: Colors.red,
                                              ).xSmall(),
                                              Gap(8),
                                              Text(e,
                                                      style: TextStyle(
                                                          color: Colors.red))
                                                  .xSmall()
                                            ],
                                          )))
                                ],
                                Gap(16),
                                PrimaryButton(
                                    onPressed:
                                        isValid ? () => _register() : null,
                                    child: Text("Register"))
                              ],
                            ))
                      ],
                    ),
                  ),
                ],
              ),
      ).constrained(minWidth: 300).iw;
}
