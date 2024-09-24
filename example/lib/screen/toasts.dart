import 'package:arcane/arcane.dart';

class ExampleToasts extends StatelessWidget {
  const ExampleToasts({super.key});

  @override
  Widget build(BuildContext context) => Screen(
        header: const Bar(
          titleText: "Dialogs",
        ),
        fill: Center(
          child: Column(
            children: [
              PrimaryButton(
                  child: const Text("Bottom Left Widget"),
                  onPressed: () => Toast(
                        location: ToastLocation.bottomLeft,
                        builder: (context) => const Text("Bottom Left"),
                      ).open(context)),
            ],
          ),
        ),
      );
}
