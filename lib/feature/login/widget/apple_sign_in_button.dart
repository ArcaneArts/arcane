import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_bloc.dart';
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
                child: SvgPicture.string('''
<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="814" height="1000"><path d="M788 341c-6 4-108 62-108 190 0 149 130 201 134 203-1 3-21 71-69 141-42 62-87 124-155 124s-86-40-164-40c-77 0-104 41-166 41s-106-57-156-127A612 612 0 0 1 0 542c0-195 126-298 251-298 66 0 121 44 163 44 39 0 101-46 176-46 28 0 131 2 198 99zM554 159c31-36 53-88 53-139 0-7 0-14-2-20-50 2-110 34-147 76-28 32-55 83-55 135l2 18 14 2c45 0 102-31 135-72z"/></svg>
''', width: 32, height: 32, color: Colors.white),
              ),
              const Text("Sign in with Apple",
                  style: TextStyle(color: Colors.white, fontSize: 18))
            ],
          ),
        ),
      );
}
