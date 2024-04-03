import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_service.dart';
import 'package:arcane/feature/service/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 25), () {
      if (svc<LoginService>().isSignedIn()) {
        success("We are already signed in");
        svc<UserService>().bind(svc<UserService>().uid()).then((v) async {
          await Arcane.app.events?.onAuthenticatedInit
              ?.call(svc<UserService>().uid());
          return v;
        }).then((value) {
          Nav.home(Arcane.context);

          Arcane.app.events?.onLaunchComplete?.call();
        });
      } else {
        verbose("Not yet signed in. Going to login.");
        Navigator.pushNamedAndRemoveUntil(
            Arcane.context, "/login", (route) => false);
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
