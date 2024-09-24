import 'package:arcane/arcane.dart';

class ExampleDialogs extends StatelessWidget {
  const ExampleDialogs({super.key});

  @override
  Widget build(BuildContext context) => Screen(
        header: const Bar(
          titleText: "Dialogs",
        ),
        fill: Center(
          child: Column(
            children: [
              PrimaryButton(
                  child: const Text("Alert Dialog"),
                  onPressed: () => DialogConfirm(
                        title: "Alert Dialog",
                        description: "This is a text description",
                        confirmText: "Yes",
                        cancelText: "Nope",
                        onConfirm: () => print("Confirmed"),
                      ).open(context)),
              const Gap(16),
              PrimaryButton(
                  child: const Text("Text Input Dialog"),
                  onPressed: () => DialogText(
                        title: "Input Dialog",
                        description: "This is a text description",
                        confirmText: "Yes",
                        cancelText: "Nope",
                        onConfirm: (x) => print("Input $x"),
                      ).open(context)),
            ],
          ),
        ),
      );
}
