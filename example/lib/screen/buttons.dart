import 'package:arcane/arcane.dart';

class ExampleButtons extends StatelessWidget {
  const ExampleButtons({super.key});

  @override
  Widget build(BuildContext context) => Screen(
        footer: Bar(
          backButton: BarBackButtonMode.never,
          titleText: "Test",
        ),
        fab: Text("I am fab"),
        header: const Bar(
          titleText: "Buttons",
        ),
        fill: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(16),
                    GhostButton(
                      onPressed: () {},
                      density: ButtonDensity.icon,
                      child: const Icon(Icons.activity),
                    ),
                    const Gap(16),
                    GhostButton(
                      child: const Text("Ghost Button"),
                      onPressed: () {},
                    ),
                    const Gap(16),
                    GhostButton(
                      onPressed: () {},
                      leading: const Icon(Icons.activity),
                      child: Text("Ghost w Icon"),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(16),
                    TextButton(
                      onPressed: () {},
                      density: ButtonDensity.icon,
                      child: Icon(Icons.activity),
                    ),
                    const Gap(16),
                    TextButton(
                      child: const Text("Text Button"),
                      onPressed: () {},
                    ),
                    const Gap(16),
                    TextButton(
                      onPressed: () {},
                      leading: const Icon(Icons.activity),
                      child: Text("Text w Icon"),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(16),
                    OutlineButton(
                      onPressed: () {},
                      density: ButtonDensity.icon,
                      child: Icon(Icons.activity),
                    ),
                    const Gap(16),
                    OutlineButton(
                      child: const Text("Outline Button"),
                      onPressed: () {},
                    ),
                    const Gap(16),
                    OutlineButton(
                      onPressed: () {},
                      leading: const Icon(Icons.activity),
                      child: Text("Outline w Icon"),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(16),
                    SecondaryButton(
                      onPressed: () {},
                      density: ButtonDensity.icon,
                      child: Icon(Icons.activity),
                    ),
                    const Gap(16),
                    SecondaryButton(
                      child: const Text("Secondary Button"),
                      onPressed: () {},
                    ),
                    const Gap(16),
                    SecondaryButton(
                      onPressed: () {},
                      leading: const Icon(Icons.activity),
                      child: Text("Secondary w Icon"),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(16),
                    PrimaryButton(
                      onPressed: () {},
                      density: ButtonDensity.icon,
                      child: Icon(Icons.activity),
                    ),
                    const Gap(16),
                    PrimaryButton(
                      child: const Text("Primary Button"),
                      onPressed: () {},
                    ),
                    const Gap(16),
                    PrimaryButton(
                      onPressed: () {},
                      leading: const Icon(Icons.activity),
                      child: Text("Primary w Icon"),
                    )
                  ],
                )
              ].map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: e,
                  ))
            ],
          ),
        ),
      );
}
