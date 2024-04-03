import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/widget/apple_sign_in_button.dart';
import 'package:arcane/feature/login/widget/google_sign_in_button.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaddingBottom(
              padding: 36,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary
                    ],
                    begin: const Alignment(0, 1),
                    end: const Alignment(1, 0),
                  ).createShader(bounds);
                },
                child: SvgPicture.string(
                  Arcane.app.svgLogo ?? arcaneArtsLogo,
                  width: 180,
                  height: 180,
                ),
              )),
          const GoogleSignInButton(),
          PaddingTop(padding: 14, child: Container()),
          Visibility(
            visible: !kIsWeb && Platform.isIOS,
            child: const AppleSignInButton(),
          ),
        ],
      );
}
