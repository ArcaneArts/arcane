import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_bloc.dart';
import 'package:arcane/feature/login/widget/login_content.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          snack("An error occurred while logging in. Please try again.");
        } else if (state == LoginState.success) {
          Get.offAndToNamed("/splash");
        }
      });
}
