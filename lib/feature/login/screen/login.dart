import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_bloc.dart';
import 'package:arcane/feature/login/screen/splash.dart';
import 'package:arcane/feature/login/widget/login_content.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends ArcaneStatelessScreen {
  final String? redirect;

  const LoginScreen({super.key, this.redirect});

  @override
  Widget build(BuildContext context) => BlocConsumer<LoginBloc, LoginState>(
      builder: (context, state) =>
          state == LoginState.loading || state == LoginState.success
              ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const Scaffold(
                  body: Align(
                    alignment: Alignment.center,
                    child: LoginContent(),
                  ),
                ),
      listener: (context, state) {
        if (state == LoginState.error) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "An error occurred while logging in. Please try again.")));
        } else if (state == LoginState.success) {
          if (redirect != null) {
            try {
              context.go(redirect!.fromRedirect);
            } catch (e, es) {
              error("Failed to decode redirect: $redirect");
              error(e);
              error(es);
              SplashScreen(
                redirect: redirect,
              ).open(context);
            }
          } else {
            const SplashScreen().open(context);
          }
        }
      });

  @override
  String toPath() => withParams("/login", {
        if (redirect != null) "redirect": redirect!,
      });

  @override
  ArcaneRoute buildRoute(
          {List<ArcaneRoute> subRoutes = const [], bool topLevel = false}) =>
      ArcaneRoute(
        path: toRegistryPath(topLevel: topLevel),
        builder: buildWithParams(
            (params) => LoginScreen(redirect: params["redirect"])),
        routes: subRoutes,
      );
}
