import 'package:arcane/arcane.dart';

class LoginContent extends StatefulWidget {
  final List<AbstractIAMButton> buttons;

  const LoginContent({super.key, required this.buttons});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  int? selected;

  @override
  Widget build(BuildContext context) => PaddingHorizontal(
      padding: 36,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(16),
            Spacer(),
            AnimatedSize(
                duration: Duration(milliseconds: 250),
                child: selected == null
                    ? AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: const SizedBox(),
                      )
                    : IndexedStack(
                        index: selected!,
                        children: [
                          for (var i = 0; i < widget.buttons.length; i++)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: i == selected
                                  ? widget.buttons[i].buildContent(context)
                                  : const SizedBox(),
                            ),
                        ],
                      )),
            Gap(16),
            Spacer(),
            Gap(16),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < widget.buttons.length; i++)
                  Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme: i == selected
                              ? Theme.of(context).colorScheme.copyWith(
                                  muted: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(1))
                              : null),
                      child: AnimatedOpacity(
                          opacity: selected == i ? 1 : 0.6,
                          duration: Duration(milliseconds: 250),
                          child: widget.buttons[i]
                              .withOnPressed(() => select(i)) as Widget)),
              ],
            ),
            Gap(16),
          ],
        ),
      ));

  void select(int i) {
    setState(() => selected = i);

    if (widget.buttons[i].isAutorun) {
      Future.delayed(Duration(milliseconds: 50), widget.buttons[i].onPressed);
    }
  }
}

abstract class AbstractIAMButton {
  VoidCallback get onPressed;

  AbstractIAMButton withOnPressed(VoidCallback onPressed);

  Widget buildContent(BuildContext context);

  bool get isAutorun;
}
