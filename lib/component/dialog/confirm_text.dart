import 'package:arcane/arcane.dart';

class DialogConfirmText extends StatefulWidget with ArcaneDialogLauncher {
  final String title;
  final String? description;
  final Widget descriptionWidget;
  final String confirmText;
  final String cancelText;
  final String verificationText;
  final void Function() onConfirm;
  final List<Widget>? actions;
  final TextInputType? keyboardType;
  final bool ignoreCase;
  final bool destructive;

  const DialogConfirmText({
    super.key,
    this.destructive = false,
    required this.title,
    this.description,
    this.descriptionWidget = const SizedBox.shrink(),
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
    required this.verificationText,
    required this.onConfirm,
    this.ignoreCase = false,
    this.actions,
    this.keyboardType,
  });

  @override
  State<DialogConfirmText> createState() => _DialogConfirmTextState();
}

class _DialogConfirmTextState extends State<DialogConfirmText>
    with TickerProviderStateMixin {
  late TextEditingController controller;
  late FocusNode focusNode;
  late AnimationController _shakeController;
  late AnimationController _colorController;
  late Animation<double> _shakeAnimation;
  Animation<Color?>? _colorAnimation;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();

    // Ooohh Shakey Shakey!
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    // make it SCARLET! lol
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorAnimation = ColorTween(
      begin: Theme.of(context).colorScheme.background,
      end: Theme.of(context).colorScheme.destructive.withOpacity(0.1),
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _colorController.dispose();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _handleError() {
    setState(() => _isError = true);
    _shakeController.forward(from: 0);
    _colorController.forward().then((_) {
      _colorController.reverse();
      controller.clear();
      setState(() => _isError = false);
      focusNode.requestFocus();
    });
  }

  bool get isValid =>
      controller.text.trim() == widget.verificationText.trim() ||
      widget.ignoreCase &&
          controller.text.trim().toLowerCase() ==
              widget.verificationText.trim().toLowerCase();

  void _handleSubmit(String value) {
    if (!isValid) {
      _handleError();
      return;
    }
    Navigator.of(context).pop(true);
    widget.onConfirm();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: ArcaneDialog(
          title: Text(widget.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.description != null ||
                  widget.descriptionWidget is! SizedBox)
                widget.description != null
                    ? Text(widget.description!)
                    : widget.descriptionWidget,
              const Gap(16),
              AnimatedBuilder(
                animation:
                    Listenable.merge([_shakeAnimation, _colorController]),
                builder: (context, child) => Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _colorAnimation?.value,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      keyboardType: widget.keyboardType,
                      maxLines: 1,
                      focusNode: focusNode,
                      controller: controller,
                      placeholder: Text(widget.verificationText),
                      onSubmitted: _handleSubmit,
                      style: TextStyle(
                        color: _isError
                            ? Theme.of(context).colorScheme.destructive
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            OutlineButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(widget.cancelText),
            ),
            widget.destructive
                ? DestructiveButton(
                    onPressed: () {
                      _handleSubmit(controller.text);
                    },
                    child: Text(widget.confirmText),
                  )
                : SecondaryButton(
                    onPressed: () {
                      _handleSubmit(controller.text);
                    },
                    child: Text(widget.confirmText),
                  ),
            if (widget.actions != null) ...widget.actions!,
          ],
        ).iw,
      );
}
