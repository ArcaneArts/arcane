import 'package:arcane/arcane.dart';

class CardCarousel extends StatefulWidget {
  final List<Widget> children;
  final int sharpness;

  const CardCarousel({super.key, this.children = const [], this.sharpness = 9});

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        SingleChildScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(mainAxisSize: MainAxisSize.min, children: widget.children),
        ),
        if (_controller.hasClients &&
            (_controller.position.pixels > 0 ||
                _controller.position.pixels <
                    _controller.position.maxScrollExtent))
          Positioned.fill(
              child: IgnorePointer(
                  ignoring: true,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutExpo,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      if (_controller.position.pixels > 0) cs.background,
                      ...List.generate(widget.sharpness.clamp(1, 12).toInt(),
                          (_) => cs.background.withOpacity(0)),
                      if (_controller.position.pixels <
                          _controller.position.maxScrollExtent)
                        cs.background
                    ])),
                  ))),
      ],
    );
  }
}
