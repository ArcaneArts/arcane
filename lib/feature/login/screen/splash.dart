import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_service.dart';
import 'package:arcane/feature/login/screen/login.dart';
import 'package:arcane/feature/service/user_service.dart';

class SplashScreen extends ArcaneStatefulScreen {
  final String? redirect;

  const SplashScreen({super.key, this.redirect});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  @override
  String toPath() => withParams("/splash", {
        if (redirect != null) "redirect": redirect!,
      });

  @override
  ArcaneRoute buildRoute(
          {List<ArcaneRoute> subRoutes = const [], bool topLevel = false}) =>
      ArcaneRoute(
        path: toRegistryPath(topLevel: topLevel),
        builder: buildWithParams(
            (params) => SplashScreen(redirect: params["redirect"])),
        routes: subRoutes,
      );
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      if (svc<LoginService>().isSignedIn()) {
        success("We are already signed in as ${svc<UserService>().uid()}");
        svc<UserService>().bind(svc<UserService>().uid()).then((v) async {
          await Arcane.app.events?.onAuthenticatedInit
              ?.call(svc<UserService>().uid());
          return v;
        }).then((value) {
          verbose("IRoute is ${Arcane.app.router.initialRoute}");
          Arcane.goHome(context);
          Arcane.app.events?.onLaunchComplete?.call();
          Arcane.dropSplash();
        });
      } else {
        svc<LoginService>().attemptAutoSignIn().then((value) {
          if (value) {
            Arcane.goHome(context);
            Arcane.app.events?.onLaunchComplete?.call();
            Arcane.dropSplash();
          } else {
            verbose("Not yet signed in. Going to login.");
            LoginScreen(
              redirect: widget.redirect,
            ).open(context);
            Arcane.dropSplash();
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: SizedBox(
      width: 100,
      height: 100,
      child: CircularProgressIndicator(),
    )));
  }
}
