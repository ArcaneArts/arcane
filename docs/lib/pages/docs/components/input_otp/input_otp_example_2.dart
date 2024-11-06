import 'package:arcane/arcane.dart';

class InputOTPExample2 extends StatelessWidget {
  const InputOTPExample2({super.key});

  @override
  Widget build(BuildContext context) {
    return InputOTP(
      initialValue: '123'.codeUnits,
      children: [
        InputOTPChild.character(allowDigit: true),
        InputOTPChild.character(allowDigit: true),
        InputOTPChild.character(allowDigit: true),
        InputOTPChild.separator,
        InputOTPChild.character(allowDigit: true),
        InputOTPChild.character(allowDigit: true),
        InputOTPChild.character(allowDigit: true),
      ],
    );
  }
}
