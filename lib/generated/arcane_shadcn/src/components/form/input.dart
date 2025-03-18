import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart'
    show
        Brightness,
        Clipboard,
        LogicalKeyboardKey,
        MaxLengthEnforcement,
        TextInputFormatter;
import 'package:arcane/generated/arcane_shadcn/shadcn_flutter.dart';

enum InputFeaturePosition {
  leading,
  trailing,
}

class InputHintFeature extends InputFeature {
  final WidgetBuilder popupBuilder;
  final Widget? icon;
  final InputFeaturePosition position;
  final bool enableShortcuts;
  const InputHintFeature({
    required this.popupBuilder,
    this.position = InputFeaturePosition.trailing,
    this.icon,
    this.enableShortcuts = true,
  });

  @override
  InputFeatureState createState() => _InputHintFeatureState();
}

class _InputHintFeatureState extends InputFeatureState<InputHintFeature> {
  final _popoverController = PopoverController();
  void _showPopup() {
    _popoverController.show(
      context: context,
      builder: feature.popupBuilder,
      alignment: feature.position == InputFeaturePosition.trailing
          ? AlignmentDirectional.topEnd
          : AlignmentDirectional.topStart,
      anchorAlignment: feature.position == InputFeaturePosition.trailing
          ? AlignmentDirectional.bottomEnd
          : AlignmentDirectional.bottomStart,
    );
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.info),
        onPressed: _showPopup,
        density: ButtonDensity.compact,
      );
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.info),
        onPressed: _showPopup,
        density: ButtonDensity.compact,
      );
    }
  }

  @override
  Iterable<MapEntry<ShortcutActivator, Intent>> buildShortcuts() sync* {
    if (feature.enableShortcuts) {
      yield const MapEntry(
        SingleActivator(LogicalKeyboardKey.f1),
        InputShowHintIntent(),
      );
    }
  }

  @override
  Iterable<MapEntry<Type, Action<Intent>>> buildActions() sync* {
    if (feature.enableShortcuts) {
      yield MapEntry(
        InputShowHintIntent,
        CallbackAction<InputShowHintIntent>(
          onInvoke: (intent) {
            _showPopup();
            return true;
          },
        ),
      );
    }
  }
}

class InputShowHintIntent extends Intent {
  const InputShowHintIntent();
}

enum PasswordPeekMode {
  hold,
  toggle,
}

class InputPasswordToggleFeature extends InputFeature {
  final PasswordPeekMode mode;
  final InputFeaturePosition position;
  final Widget? icon;
  final Widget? iconShow;
  const InputPasswordToggleFeature({
    this.icon,
    this.iconShow,
    this.mode = PasswordPeekMode.toggle,
    this.position = InputFeaturePosition.trailing,
  });

  @override
  InputFeatureState createState() => _InputPasswordToggleFeatureState();
}

class _InputPasswordToggleFeatureState
    extends InputFeatureState<InputPasswordToggleFeature> {
  bool? _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      if (_obscureText == null) {
        _obscureText = true;
      } else {
        _obscureText = null;
      }
    });
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield _buildIconButton();
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield _buildIconButton();
    }
  }

  Widget _buildIcon() {
    if (_obscureText == true || input.obscureText) {
      return feature.icon ?? const Icon(LucideIcons.eye);
    }
    return feature.iconShow ?? const Icon(LucideIcons.eyeOff);
  }

  Widget _buildIconButton() {
    if (feature.mode == PasswordPeekMode.hold) {
      return IconButton.text(
        icon: _buildIcon(),
        onTapDown: (_) {
          setState(() {
            _obscureText = null;
          });
        },
        onTapUp: (_) {
          setState(() {
            _obscureText = true;
          });
        },
        enabled: true,
        density: ButtonDensity.compact,
      );
    }
    return IconButton.text(
      icon: _buildIcon(),
      onPressed: _toggleObscureText,
      density: ButtonDensity.compact,
    );
  }

  @override
  TextField interceptInput(TextField input) {
    return input.copyWith(
      obscureText: _obscureText,
    );
  }
}

class InputClearFeature extends InputFeature {
  final InputFeaturePosition position;
  final Widget? icon;
  const InputClearFeature({
    this.position = InputFeaturePosition.trailing,
    this.icon,
  });

  @override
  InputFeatureState createState() => _InputClearFeatureState();
}

class _InputClearFeatureState extends InputFeatureState<InputClearFeature> {
  void _clear() {
    invokeActionOnFocusedWidget(const TextFieldClearIntent());
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.x),
        onPressed: _clear,
        density: ButtonDensity.compact,
      );
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.x),
        onPressed: _clear,
        density: ButtonDensity.compact,
      );
    }
  }
}

class InputRevalidateFeature extends InputFeature {
  final InputFeaturePosition position;
  final Widget? icon;
  const InputRevalidateFeature({
    this.position = InputFeaturePosition.trailing,
    this.icon,
  });

  @override
  InputFeatureState createState() => _InputRevalidateFeatureState();
}

class _InputRevalidateFeatureState
    extends InputFeatureState<InputRevalidateFeature> {
  void _revalidate() {
    var formFieldHandle = Data.maybeFind<FormFieldHandle>(context);
    if (formFieldHandle != null) {
      formFieldHandle.revalidate();
    }
  }

  Widget _buildIcon() {
    return FormPendingBuilder(
      builder: (context, futures, _) {
        if (futures.isEmpty) {
          return IconButton.text(
            icon: feature.icon ?? const Icon(LucideIcons.refreshCw),
            onPressed: _revalidate,
            density: ButtonDensity.compact,
          );
        }

        var futureAll = Future.wait(futures.values);
        return FutureBuilder(
          future: futureAll,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return IconButton.text(
                icon: RepeatedAnimationBuilder(
                  start: 0.0,
                  end: 360.0,
                  duration: const Duration(seconds: 1),
                  child: feature.icon ?? const Icon(LucideIcons.refreshCw),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: degToRad(value),
                      child: child,
                    );
                  },
                ),
                onPressed: null,
                density: ButtonDensity.compact,
              );
            }
            return IconButton.text(
              icon: feature.icon ?? const Icon(LucideIcons.refreshCw),
              onPressed: _revalidate,
              density: ButtonDensity.compact,
            );
          },
        );
      },
    );
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield _buildIcon();
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield _buildIcon();
    }
  }
}

typedef SuggestionBuilder = FutureOr<Iterable<String>> Function(String query);

class InputAutoCompleteFeature extends InputFeature {
  final SuggestionBuilder querySuggestions;
  final Widget child;
  final BoxConstraints? popoverConstraints;
  final PopoverConstraint? popoverWidthConstraint;
  final AlignmentDirectional? popoverAnchorAlignment;
  final AlignmentDirectional? popoverAlignment;
  final AutoCompleteMode mode;

  const InputAutoCompleteFeature({
    required this.querySuggestions,
    required this.child,
    this.popoverConstraints,
    this.popoverWidthConstraint,
    this.popoverAnchorAlignment,
    this.popoverAlignment,
    this.mode = AutoCompleteMode.replaceWord,
  });

  @override
  InputFeatureState createState() => _AutoCompleteFeatureState();
}

class _AutoCompleteFeatureState
    extends InputFeatureState<InputAutoCompleteFeature> {
  final GlobalKey _key = GlobalKey();
  final ValueNotifier<FutureOr<Iterable<String>>?> _suggestions =
      ValueNotifier(null);

  @override
  void onTextChanged(String text) {
    _suggestions.value = feature.querySuggestions(text);
  }

  @override
  Widget wrap(Widget child) {
    return ListenableBuilder(
      listenable: _suggestions,
      builder: (context, child) {
        var suggestions = _suggestions.value;
        if (suggestions is Future<Iterable<String>>) {
          return FutureBuilder(
            future: suggestions,
            builder: (context, snapshot) {
              return AutoComplete(
                key: _key,
                suggestions:
                    snapshot.hasData ? snapshot.requireData.toList() : const [],
                popoverConstraints: feature.popoverConstraints,
                popoverWidthConstraint: feature.popoverWidthConstraint,
                popoverAnchorAlignment: feature.popoverAnchorAlignment,
                popoverAlignment: feature.popoverAlignment,
                mode: feature.mode,
                child: child!,
              );
            },
          );
        }
        return AutoComplete(
          key: _key,
          suggestions: suggestions == null ? const [] : suggestions.toList(),
          popoverConstraints: feature.popoverConstraints,
          popoverWidthConstraint: feature.popoverWidthConstraint,
          popoverAnchorAlignment: feature.popoverAnchorAlignment,
          popoverAlignment: feature.popoverAlignment,
          mode: feature.mode,
          child: child!,
        );
      },
      child: child,
    );
  }
}

class InputSpinnerFeature extends InputFeature {
  final double step;
  final bool enableGesture;
  final double? invalidValue;
  const InputSpinnerFeature({
    this.step = 1.0,
    this.enableGesture = true,
    this.invalidValue = 0.0,
  });

  @override
  InputFeatureState createState() => _InputSpinnerFeatureState();
}

class _InputSpinnerFeatureState extends InputFeatureState<InputSpinnerFeature> {
  void _replaceText(UnaryOperator<String> replacer) {
    var controller = this.controller;
    var text = controller.text;
    var newText = replacer(text);
    if (newText != text) {
      controller.text = newText;
    }
  }

  void _increase() {
    _replaceText((text) {
      var value = double.tryParse(text);
      if (value == null) {
        if (feature.invalidValue != null) {
          return feature.invalidValue.toString();
        }
        return text;
      }
      return (value + feature.step).toString();
    });
  }

  void _decrease() {
    _replaceText((text) {
      var value = double.tryParse(text);
      if (value == null) {
        if (feature.invalidValue != null) {
          return feature.invalidValue.toString();
        }
        return text;
      }
      return (value - feature.step).toString();
    });
  }

  Widget _wrapGesture(Widget child) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 0) {
          _increase();
        } else {
          _decrease();
        }
      },
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! > 0) {
          _increase();
        } else {
          _decrease();
        }
      },
      child: child,
    );
  }

  Widget _buildButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.text(
          icon: const Icon(LucideIcons.chevronUp),
          onPressed: _increase,
          density: ButtonDensity.compact,
          size: ButtonSize.xSmall,
        ),
        IconButton.text(
          icon: const Icon(LucideIcons.chevronDown),
          onPressed: _decrease,
          density: ButtonDensity.compact,
          size: ButtonSize.xSmall,
        ),
      ],
    );
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.enableGesture) {
      yield _wrapGesture(_buildButtons());
    } else {
      yield _buildButtons();
    }
  }
}

class InputCopyFeature extends InputFeature {
  final InputFeaturePosition position;
  final Widget? icon;
  const InputCopyFeature({
    this.position = InputFeaturePosition.trailing,
    this.icon,
  });

  @override
  InputFeatureState createState() => _InputCopyFeatureState();
}

class _InputCopyFeatureState extends InputFeatureState<InputCopyFeature> {
  void _copy() {
    invokeActionOnFocusedWidget(const TextFieldSelectAllAndCopyIntent());
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.copy),
        onPressed: _copy,
        density: ButtonDensity.compact,
      );
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.copy),
        onPressed: _copy,
        density: ButtonDensity.compact,
      );
    }
  }
}

class InputLeadingFeature extends InputFeature {
  final Widget prefix;
  const InputLeadingFeature(this.prefix);

  @override
  InputFeatureState createState() => _InputLeadingFeatureState();
}

class _InputLeadingFeatureState extends InputFeatureState<InputLeadingFeature> {
  @override
  Iterable<Widget> buildLeading() sync* {
    yield feature.prefix;
  }
}

class InputTrailingFeature extends InputFeature {
  final Widget suffix;
  const InputTrailingFeature(this.suffix);

  @override
  InputFeatureState createState() => _InputTrailingFeatureState();
}

class _InputTrailingFeatureState
    extends InputFeatureState<InputTrailingFeature> {
  @override
  Iterable<Widget> buildTrailing() sync* {
    yield feature.suffix;
  }
}

class InputPasteFeature extends InputFeature {
  final InputFeaturePosition position;
  final Widget? icon;
  const InputPasteFeature({
    this.position = InputFeaturePosition.trailing,
    this.icon,
  });

  @override
  InputFeatureState createState() => _InputPasteFeatureState();
}

class _InputPasteFeatureState extends InputFeatureState<InputPasteFeature> {
  void _paste() {
    var clipboardData = Clipboard.getData('text/plain');
    clipboardData.then((value) {
      if (value != null) {
        var text = value.text;
        if (text != null && text.isNotEmpty) {
          invokeActionOnFocusedWidget(TextFieldAppendTextIntent(text: text));
        }
      }
    });
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.clipboard),
        onPressed: _paste,
        density: ButtonDensity.compact,
      );
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield IconButton.text(
        icon: feature.icon ?? const Icon(LucideIcons.clipboard),
        onPressed: _paste,
        density: ButtonDensity.compact,
      );
    }
  }
}
