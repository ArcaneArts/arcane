import 'package:arcane/arcane.dart';

class OpalBackground extends StatelessWidget {
  final Widget? child;

  const OpalBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        color: Theme.of(context)
            .colorScheme
            .surface
            .withOpacity(Arcane.opal.canvasOpacity.value),
        duration: const Duration(seconds: 1),
        curve: Curves.easeOutCirc,
        child: AnimatedOpacity(
          opacity: Arcane.opal.backgroundOpacity.value,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOutCirc,
          child: child ??
              UnicornVomit(
                dark: Arcane.opal.isDark(),
                points: 3,
                blendAmount: Arcane.opal.themeColorMixture.value,
                blendColor: Arcane.opal.theme.colorScheme.primary,
              ),
        ),
      );
}
