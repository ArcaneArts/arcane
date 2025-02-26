import 'package:arcane/arcane.dart';

class WindowBar extends StatelessWidget {
  final Widget child;
  const WindowBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Widget? barHeader = context.pylonOr<InjectBarHeader>()?.header.call(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,


      children: [
        if (barHeader != null) ColoredBox(color: Theme.of(context).colorScheme.background, child: barHeader),
        Expanded(
          child: PylonRemove<InjectBarHeader>(builder: (context) => child),
        )
      ],);
  }
}
