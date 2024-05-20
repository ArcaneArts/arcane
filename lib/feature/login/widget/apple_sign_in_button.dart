import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_bloc.dart';
import 'package:common_svgs/common_svgs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => context.read<LoginBloc>().add(LoginAppleEvent()),
        child: PaddingAll(
          padding: 14,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaddingRight(
                padding: 14,
                child: SvgPicture.string(svgApple,
                    width: 32, height: 32, color: Colors.white),
              ),
              const Text("Sign in with Apple",
                  style: TextStyle(color: Colors.white, fontSize: 18))
            ],
          ),
        ),
      );
}
