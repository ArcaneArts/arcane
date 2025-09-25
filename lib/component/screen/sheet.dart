import 'package:arcane/arcane.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// A signal used to detect if the current build context is inside a [Sheet] presentation.
class InsideSheetSignal {
  const InsideSheetSignal();
}

/// Extension on [BuildContext] to check if the current context is within a [Sheet].
extension XBuildContextSheetSignal on BuildContext {
  bool get inSheet => pylonOr<InsideSheetSignal>() != null;
}

/// A mixin for widgets that can launch as modal bottom sheets in Arcane UI, providing
/// dismissible control and smooth animated presentations integrated with [ArcaneApp]
/// and [ArcaneTheme] for consistent theming and accessibility.
mixin ArcaneSheetLauncher on Widget {
  /// Whether the sheet can be dismissed by dragging or tapping outside.
  bool get isDismissible;

  /// Launches this widget as a modal bottom sheet using [showCupertinoModalBottomSheet],
  /// with Expo easing animation, bounce effect, and Pylon context mirroring for
  /// internal signal propagation. Supports scrollable content via [DraggableScrollableSheet]
  /// integration and efficient rendering in modals.
  ///
  /// Returns the result from the sheet's navigator or null if dismissed.
  Future<T?> open<T>(BuildContext context) {
    PylonBuilder builder = Pylon.mirror(context, (context) => this);
    return showCupertinoModalBottomSheet(
      duration: const Duration(milliseconds: 500),
      isDismissible: isDismissible,
      bounce: true,
      enableDrag: isDismissible,
      animationCurve: Curves.easeOutExpo,
      context: context,
      builder: builder,
    );
  }
}

/// A [StatelessWidget] for presenting modal bottom sheets in Arcane UI, extending
/// [AbstractScreen] patterns for content encapsulation while using [showCupertinoModalBottomSheet]
/// for native-like presentations. Integrates with [Sidebar], [BottomNavigationBar], and
/// [ArcaneTheme] for themed drag handles, backgrounds, and elevations; supports
/// [SliverList] or [SafeArea] for scrollable, keyboard-avoiding content with smooth
/// animations and performance-optimized rendering.
class Sheet extends StatelessWidget with ArcaneSheetLauncher {
  /// The builder function that constructs the sheet's content widget, receiving
  /// the sheet-specific [BuildContext] for theming and signal access.
  final Widget Function(BuildContext context) builder;

  /// Whether the sheet is dismissible via drag or outside taps; defaults to true
  /// for standard modal behavior, set to false for persistent sheets like settings.
  final bool dismissible;

  /// Creates a new [Sheet] with the required content builder and optional dismissibility.
  ///
  /// Use within [ArcaneApp] to ensure theme adaptation; pair with [DraggableScrollableSheet]
  /// for resizable sheets or [KeyboardAvoider] for form inputs.
  const Sheet({super.key, required this.builder, this.dismissible = true});

  @override
  Widget build(BuildContext context) => Pylon<InsideSheetSignal>(
        value: const InsideSheetSignal(),
        builder: builder,
      );

  @override
  bool get isDismissible => dismissible;
}
