import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_bloc.dart';
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
                child: SvgPicture.string('''
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"><path fill="#4285F4" d="M24 12v-2H12v5h7l-3 3v3h4c2-2 4-5 4-9Z"/><path fill="#34A853" d="M12 24c3 0 6-1 8-3l-4-3a7 7 0 0 1-10-4H2v3c2 4 6 7 10 7Z"/><path fill="#FBBC05" d="M6 14a7 7 0 0 1 0-4V7H2a12 12 0 0 0 0 10l4-3Z"/><path fill="#EA4335" d="M12 5c2 0 4 0 5 2l3-4c-2-2-5-3-8-3C8 0 4 3 2 7l4 3c0-3 3-5 6-5Z"/></svg>
''', width: 32, height: 32),
              ),
              const Text("Sign in with Google",
                  style: TextStyle(color: Colors.white, fontSize: 18))
            ],
          ),
        ),
      );
}
