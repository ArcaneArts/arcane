import 'package:arcane/arcane.dart';

class InputOTPExample4 extends StatelessWidget {
  const InputOTPExample4({super.key});

  @override
  Widget build(BuildContext context) {
    return InputOTP(
      children: [
        InputOTPChild.character(
            allowLowercaseAlphabet: true,
            allowUppercaseAlphabet: true,
            onlyUppercaseAlphabet: true),
        InputOTPChild.character(
            allowLowercaseAlphabet: true,
            allowUppercaseAlphabet: true,
            onlyUppercaseAlphabet: true),
        InputOTPChild.character(
            allowLowercaseAlphabet: true,
            allowUppercaseAlphabet: true,
            onlyUppercaseAlphabet: true),
        InputOTPChild.separator,
        InputOTPChild.character(
            allowLowercaseAlphabet: true,
            allowUppercaseAlphabet: true,
            onlyUppercaseAlphabet: true),
        InputOTPChild.character(
            allowLowercaseAlphabet: true,
            allowUppercaseAlphabet: true,
            onlyUppercaseAlphabet: true),
        InputOTPChild.character(
            allowLowercaseAlphabet: true,
            allowUppercaseAlphabet: true,
            onlyUppercaseAlphabet: true),
        InputOTPChild.separator,
        InputOTPChild.character(
            allowLowercaseAlphabet: true,
            allowUppercaseAlphabet: true,
            onlyUppercaseAlphabet: true),
        InputOTPChild.character(
            allowLowercaseAlphabet: true,
            allowUppercaseAlphabet: true,
            onlyUppercaseAlphabet: true),
        InputOTPChild.character(
            allowLowercaseAlphabet: true,
            allowUppercaseAlphabet: true,
            onlyUppercaseAlphabet: true),
      ],
    );
  }
}
