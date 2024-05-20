import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_bloc.dart';
import 'package:common_svgs/common_svgs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => context.read<LoginBloc>().add(LoginGoogleEvent()),
        child: PaddingAll(
          padding: 14,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaddingRight(
                padding: 14,
                child: SvgPicture.string(svgGoogle, width: 32, height: 32),
              ),
              const Text("Sign in with Google",
                  style: TextStyle(color: Colors.white, fontSize: 18))
            ],
          ),
        ),
      );
}
