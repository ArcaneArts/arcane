import 'package:arcane/arcane.dart';

class OpalBackground extends StatelessWidget {
  final Opal controller;
  const OpalBackground({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
      opacity: controller.backgroundOpacity.value,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutCirc,
      child: UnicornVomit(
        dark: controller.isDark(),
        points: 3,
        blendAmount: controller.themeColorMixture.value,
        blendColor: controller.theme.colorScheme.primary,
      ));
}
