import 'package:arcane/arcane.dart';
import 'package:faker/faker.dart';

typedef ListTile = Tile;
typedef SwitchListTile = SwitchTile;
typedef CheckboxListTile = CheckboxTile;

/// TileWidgetPosition enum defines the possible positions for interactive widgets like switches or checkboxes within a [Tile].
///
/// - [leading]: Positions the widget on the left side of the tile content.
/// - [trailing]: Positions the widget on the right side of the tile content.
///
/// This enum is used in Arcane UI components like [SwitchTile] and [CheckboxTile] to control layout flexibility, ensuring efficient rendering without unnecessary rebuilds when integrated into [Section] or [SliverScreen] for list-based interfaces.
enum TileWidgetPosition { leading, trailing }

/// SwitchTile is a stateless widget that extends [Tile] to provide a toggleable switch interface, ideal for settings or selection lists in Arcane UI.
///
/// Key features:
/// - Integrates seamlessly with [ArcaneTheme] for consistent styling and [Gesture] for touch interactions.
/// - Supports leading or trailing switch positioning via [TileWidgetPosition] for flexible layouts.
/// - Efficient state management: No unnecessary rebuilds as it delegates to [Tile]'s build logic, suitable for use in [FillScreen] or [SliverScreen] without performance overhead.
/// - Usage: Wrap in [Section] for grouped settings, e.g., in a [NavigationScreen] sidebar; toggle calls [onChanged] to update parent state efficiently.
class SwitchTile extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool? value;
  final EdgeInsets contentPadding;
  final EdgeInsets leadingPadding;
  final EdgeInsets trailingPadding;
  final bool sliver;
  final double knownIconSize;
  final TileWidgetPosition checkPosition;
  final ValueChanged<bool>? onChanged;

  /// Creates a [SwitchTile] with customizable content and switch behavior.
  ///
  /// - The [title] and [subtitle] define the primary and secondary text, styled via [ArcaneTheme].
  /// - [leading] and [trailing] allow custom widgets; the switch position is controlled by [checkPosition] (defaults to trailing).
  /// - [value] represents the switch state (null defaults to false); [onChanged] handles toggle callbacks, converting to bool.
  /// - Padding defaults: [contentPadding] for overall spacing, [leadingPadding] and [trailingPadding] for icon alignment.
  /// - [sliver] enables sliver mode for [SliverScreen] integration; [knownIconSize] optimizes layout calculations.
  /// Initialization uses const constructor for performance, promoting reuse in lists without rebuilds.
  const SwitchTile({
    super.key,
    this.checkPosition = TileWidgetPosition.trailing,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onChanged,
    this.knownIconSize = 20,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
    this.leadingPadding = const EdgeInsets.only(right: 10, top: 4),
    this.trailingPadding = const EdgeInsets.only(left: 10, top: 4),
    this.sliver = false,
    this.value,
  });

  Widget buildSwitch(
    BuildContext context, {
    Widget? leading,
    Widget? trailing,
  }) =>
      Switch(
        leading: leading,
        trailing: trailing,
        value: value ?? false,
        onChanged: (v) =>
            onChanged != null ? onChanged!(v == CheckboxState.checked) : null,
      );

  /// Overrides [StatelessWidget.build] to compose a [Tile] with embedded switch.
  ///
  /// Inputs: Build context.
  /// Outputs: A [Tile] widget with switch positioned per [checkPosition].
  /// Logic: Conditionally places switch in leading or trailing; sets [onPressed] to toggle if [onChanged] provided; applies all paddings and [sliver] mode for efficient rendering in [Section] or [FillScreen].
  @override
  Widget build(BuildContext context) => Tile(
        title: title,
        subtitle: subtitle,
        leading: checkPosition == TileWidgetPosition.leading
            ? buildSwitch(context, leading: leading)
            : leading,
        trailing: checkPosition == TileWidgetPosition.trailing
            ? buildSwitch(context, trailing: trailing)
            : trailing,
        onPressed:
            onChanged != null ? () => onChanged!(!(value ?? false)) : null,
        contentPadding: contentPadding,
        leadingPadding: leadingPadding,
        trailingPadding: trailingPadding,
        sliver: sliver,
        knownIconSize: knownIconSize,
      );
}

/// CheckboxTile is a stateless widget extending [Tile] for tri-state checkbox functionality, suitable for multi-select or indeterminate states in Arcane UI lists.
///
/// Key features:
/// - Supports [tristate] for null/indeterminate states, integrating with [ArcaneTheme] colors and [Gesture] for interactions.
/// - Flexible positioning of checkbox via [TileWidgetPosition]; optional [leadingIcon] for visual enhancement.
/// - Performance: Leverages [Tile]'s efficient build without extra state; ideal for large lists in [SliverScreen] or [FillScreen] with no rebuild overhead.
/// - Usage: Embed in [Section] for task checklists or filters in [NavigationScreen]; [onChanged] updates parent with bool? for indeterminate handling.

class CheckboxTile extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool? value;
  final EdgeInsets contentPadding;
  final EdgeInsets leadingPadding;
  final EdgeInsets trailingPadding;
  final bool sliver;
  final double knownIconSize;
  final TileWidgetPosition checkPosition;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;
  final String? subtitleText;
  final String? titleText;
  final IconData? leadingIcon;

  /// Creates a [CheckboxTile] with text or widget content and checkbox configuration.
  ///
  /// - [title] or [titleText], [subtitle] or [subtitleText] for content; prioritizes text if provided for simple strings.
  /// - [leadingIcon] adds an icon if no [leading] widget; [checkPosition] defaults to trailing for checkbox placement.
  /// - [tristate] enables null state (default false); [value] maps to [CheckboxState] (unchecked/false, indeterminate/null, checked/true).
  /// - [onChanged] receives bool? output; paddings and [sliver] for layout in [Section] or slivers.
  /// - [knownIconSize] aids precise alignment; const constructor ensures const instances for performance.
  const CheckboxTile({
    super.key,
    this.checkPosition = TileWidgetPosition.trailing,
    this.title,
    this.subtitle,
    this.leadingIcon,
    this.titleText,
    this.subtitleText,
    this.leading,
    this.trailing,
    this.tristate = false,
    this.onChanged,
    this.knownIconSize = 20,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
    this.leadingPadding = const EdgeInsets.only(right: 10, top: 4),
    this.trailingPadding = const EdgeInsets.only(left: 10, top: 4),
    this.sliver = false,
    this.value,
  });

  Widget buildCheckbox(
    BuildContext context, {
    Widget? leading,
    Widget? trailing,
  }) =>
      Checkbox(
        leading: leading,
        tristate: tristate,
        trailing: trailing,
        state: value == false
            ? CheckboxState.unchecked
            : value == null
                ? CheckboxState.indeterminate
                : CheckboxState.checked,
        onChanged: (v) => onChanged != null
            ? onChanged!(v == CheckboxState.checked
                ? true
                : v == CheckboxState.indeterminate
                    ? null
                    : false)
            : null,
      );

  /// Overrides [StatelessWidget.build] to integrate checkbox into [Tile].
  ///
  /// Inputs: Build context.
  /// Outputs: [Tile] with checkbox positioned and text/icon handling.
  /// Logic: Uses text if provided over widgets; places checkbox per [checkPosition], adding [leadingIcon] if needed; [onPressed] toggles if [onChanged] exists; applies paddings for [SliverScreen] compatibility.
  @override
  Widget build(BuildContext context) => Tile(
        title: titleText != null ? Text(titleText!) : title,
        subtitle: subtitleText != null ? Text(subtitleText!) : subtitle,
        leading: checkPosition == TileWidgetPosition.leading
            ? buildCheckbox(context,
                trailing: leadingIcon != null ? Icon(leadingIcon!) : leading)
            : leadingIcon != null
                ? Icon(leadingIcon!)
                : leading,
        trailing: checkPosition == TileWidgetPosition.trailing
            ? buildCheckbox(context, trailing: trailing)
            : trailing,
        onPressed:
            onChanged != null ? () => onChanged!(!(value ?? false)) : null,
        contentPadding: contentPadding,
        leadingPadding: leadingPadding,
        trailingPadding: trailingPadding,
        sliver: sliver,
        knownIconSize: knownIconSize,
      );
}

/// Tile is the core stateless widget for creating list tiles in Arcane UI, supporting expandable content and sliver modes for flexible layouts.
///
/// Key features:
/// - Composable with [BasicCard] or [Glass] for containment; uses [ArcaneTheme] for typography and colors.
/// - Expandable via [Expander] integration for nested content without full rebuilds, efficient for [FillScreen] details or [Section] items.
/// - Sliver support for [SliverScreen]; static [loading] for placeholders with shimmer effects.
/// - Performance: Const constructor, inline getters for styled text, no state management overhead; animations use Curves.easeOutCirc for smooth expansions.
/// - Usage: Primary building block for lists in [NavigationScreen]; pair with [Gesture] for interactions, embed in [Section] for grouped UI.

class Tile extends StatelessWidget {
  final Widget? title;
  final String? titleText;
  final Widget? subtitle;
  final String? subtitleText;
  final Widget? leading;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final EdgeInsets contentPadding;
  final EdgeInsets leadingPadding;
  final EdgeInsets trailingPadding;
  final bool sliver;
  final double knownIconSize;
  final List<Widget> children;

  final bool initiallyExpanded;
  final ExpanderController? expansionController;
  final Duration expandDuration;
  final Curve expandCurve;
  final AlignmentGeometry expandAlignment;
  final Duration expandReverseDuration;
  final CrossAxisAlignment expanderCrossAxisAlignment;
  final double expanderGapPadding;

  /// Creates a [Tile] with content, interaction, and expansion options.
  ///
  /// - [title] or [titleText], [subtitle] or [subtitleText] for display; [leading] or [leadingIcon], [trailing] for icons/widgets.
  /// - [onPressed] enables tappable behavior; [children] for expandable content (requires [Expander] params).
  /// - Expansion: [initiallyExpanded], [expansionController], durations/curves for animations; [expanderGapPadding] and alignment for layout.
  /// - Paddings: [contentPadding] (default symmetric), [leadingPadding]/[trailingPadding] for alignment; [sliver] for sliver mode; [knownIconSize] optimizes spacing.
  /// - Defaults promote const usage; [children] empty by default, no expansion if absent.
  const Tile({
    super.key,
    this.leadingIcon,
    this.titleText,
    this.subtitleText,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPressed,
    this.knownIconSize = 20,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    this.leadingPadding = const EdgeInsets.only(right: 10, top: 4),
    this.trailingPadding = const EdgeInsets.only(left: 10, top: 4),
    this.sliver = false,
    this.children = const [],
    this.initiallyExpanded = false,
    this.expansionController,
    this.expandDuration = const Duration(milliseconds: 250),
    this.expandCurve = Curves.easeOutCirc,
    this.expandAlignment = Alignment.topCenter,
    this.expandReverseDuration = const Duration(milliseconds: 250),
    this.expanderCrossAxisAlignment = CrossAxisAlignment.start,
    this.expanderGapPadding = 8,
  });

  static Widget loading(
          {bool title = true,
          bool subtitle = true,
          bool leading = true,
          int? subtitleMaxLines = 2,
          bool trailing = false}) =>
      ListTile(
        title: title
            ? Text(faker.lorem
                .words(faker.randomGenerator.integer(7, min: 3))
                .join(" "))
            : null,
        subtitle: subtitle
            ? Text(
                faker.lorem
                    .sentences(faker.randomGenerator.integer(3, min: 1))
                    .join(" "),
                maxLines: subtitleMaxLines,
              )
            : null,
      ).shimmer();

  Widget get styledSubtitle =>
      subtitle is Text ? subtitle!.small().muted() : subtitle!;

  Widget get styledTitle => title is Text ? title!.medium() : title!;

  Widget buildTile(BuildContext context) => Padding(
      padding: context.pylonOr<OverrideEdgeInsets>()?.insets ?? contentPadding,
      child: Row(
        children: [
          Expanded(
              child: Basic(
            leadingAlignment: Alignment.center,
            trailingAlignment: Alignment.center,
            leading: leading,
            trailing: trailing ??
                (children.isNotEmpty
                    ? IconButton(
                        icon: Icon(context.pylon<ExpanderState>().expanded
                            ? Icons.chevron_up_ionic
                            : Icons.chevron_down_ionic),
                        onPressed: () {})
                    : null),
            title: titleText != null ? Text(titleText!) : title,
            subtitle: subtitleText != null ? Text(subtitleText!) : subtitle,
          ))
        ],
      ));

  Widget buildSliver(BuildContext context) => GlassSection(
      header: Padding(
          padding:
              context.pylonOr<OverrideEdgeInsets>()?.insets ?? contentPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null && leadingIcon == null)
                Padding(
                  padding: EdgeInsets.only(right: leadingPadding.right),
                  child: leading ?? Icon(leadingIcon),
                ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null || titleText != null)
                    DefaultTextStyle(
                        style: Theme.of(context).typography.medium.copyWith(
                            color: Theme.of(context).colorScheme.foreground),
                        child: title ?? Text(titleText!)),
                ],
              )),
              if (trailing != null)
                Padding(
                  padding: EdgeInsets.only(right: trailingPadding.left),
                  child: trailing!,
                )
            ],
          )),
      sliver: SliverToBoxAdapter(
        child: Padding(
            padding: EdgeInsets.only(
                left: contentPadding.left +
                    (leading != null || leadingIcon != null
                        ? (leadingPadding.right +
                            leadingPadding.left +
                            knownIconSize)
                        : 0),
                right: 18,
                bottom: 4),
            child: Row(
              children: [
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subtitle != null || subtitleText != null)
                      DefaultTextStyle(
                              style: Theme.of(context)
                                  .typography
                                  .small
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .foreground),
                              child: subtitle ?? Text(subtitleText!))
                          .withOpacity(0.9),
                  ],
                ))
              ],
            )),
      ));

  /// Overrides [StatelessWidget.build] to handle expansion, sliver, and interactions.
  ///
  /// Inputs: Build context.
  /// Outputs: [Expander] if [children] present, else sliver or standard tile.
  /// Logic: Asserts no children in sliver mode; builds via [buildTile] or [buildSliver]; for expansion, uses [Expander] with animations (fadeIn for children, divider separator); ignores pointer on header to prevent conflicts; applies blurIn for smooth entry.
  @override
  Widget build(BuildContext context) {
    assert((sliver && children.isEmpty) || !sliver,
        'Sliver tiles cannot have children');

    Widget _build(BuildContext context) => onPressed != null
        ? GhostButton(
            onPressed: onPressed,
            density: ButtonDensity.compact,
            child: buildTile(context))
        : buildTile(context);

    if (children.isNotEmpty) {
      return Expander(
        initiallyExpanded: initiallyExpanded,
        controller: expansionController,
        duration: expandDuration,
        reverseDuration: expandReverseDuration,
        curve: expandCurve,
        alignment: expandAlignment,
        gapPadding: expanderGapPadding,
        crossAxisAlignment: expanderCrossAxisAlignment,
        header: Builder(
            builder: (context) => IgnorePointer(
                  ignoring: true,
                  child: _build(context),
                )),
        overrideSeparator: Divider().animate().fadeIn(
              duration: expandDuration * 4,
              curve: expandCurve,
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...children.mapIndexed((i, index) => i.animate().fadeIn(
                duration: expandDuration * 4,
                curve: expandCurve,
                delay: Duration(milliseconds: 40 * index)))
          ],
        ),
      );
    }

    return sliver ? buildSliver(context) : _build(context);
  }
}

/// MagicTile is an adaptive stateless widget extending [Tile] with responsive design and context menu, using [BoxSignal] for dynamic sizing in Arcane UI.
///
/// Key features:
/// - Responsive: Adjusts leading/trailing based on screen width thresholds; wraps in [GlowCard] for fat layouts with thumbhash blur.
/// - Context menu integration via [ContextMenu] for right-click actions; essential flags ensure critical elements always show.
/// - Performance: [BoxSignal] for width-based adaptations without rebuilds; animated switcher for layout changes; efficient for [FillScreen] or [SliverScreen] in varying device sizes.
/// - Usage: Ideal for dynamic lists in [NavigationScreen]; combine with [ArcaneTheme] for translucent surfaces; [thumbHash] enables image previews without full loads.

class MagicTile extends StatelessWidget with BoxSignal {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final String? titleText;
  final String? subtitleText;
  final IconData? leadingIcon;
  final bool essentialLeading;
  final bool essentialTrailing;
  final List<MenuItem> contextMenu;
  final bool contextMenuEnabled;
  final bool fatPad;
  final double fatThreshold;
  final double leadingThreshold;
  final double trailingThreshold;
  final String? thumbHash;

  /// Creates a [MagicTile] with responsive and menu options.
  ///
  /// - [title]/[titleText], [subtitle]/[subtitleText], [leading]/[leadingIcon], [trailing] for content; [onPressed] for taps.
  /// - Responsiveness: [fatThreshold], [leadingThreshold], [trailingThreshold] control layout (defaults 500/300/350); [essentialLeading]/[essentialTrailing] force visibility; [fatPad] adds horizontal padding in fat mode.
  /// - Menu: [contextMenu] list of [MenuItem], [contextMenuEnabled] toggles (default false); [thumbHash] for [GlowCard] blur.
  /// - Const constructor; uses [BoxSignal] for width-based adaptations without state.
  const MagicTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.thumbHash,
    this.onPressed,
    this.titleText,
    this.subtitleText,
    this.leadingIcon,
    this.contextMenu = const [],
    this.fatPad = true,
    this.contextMenuEnabled = false,
    this.essentialLeading = false,
    this.essentialTrailing = true,
    this.fatThreshold = 500,
    this.leadingThreshold = 300,
    this.trailingThreshold = 350,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ContextMenu(
        items: contextMenu,
        enabled: contextMenuEnabled && contextMenu.isNotEmpty,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: width > fatThreshold
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: fatPad ? 16 : 0, vertical: 4),
                  child: GlowCard(
                    thumbHash: thumbHash,
                    surfaceOpacity: context.isTranslucent
                        ? ArcaneTheme.of(context).surfaceOpacity
                        : null,
                    surfaceBlur: context.isTranslucent
                        ? ArcaneTheme.of(context).surfaceBlur
                        : null,
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: leading != null &&
                                  leading is Icon &&
                                  (leading as Icon).color != null
                              ? (leading as Icon).color!.withOpacity(0.1)
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: leadingIcon != null
                            ? Icon(leadingIcon,
                                color: leading != null &&
                                        leading is Icon &&
                                        (leading as Icon).color != null
                                    ? (leading as Icon).color!
                                    : Theme.of(context)
                                        .colorScheme
                                        .accentForeground)
                            : leading != null && leading is Icon
                                ? Icon((leading as Icon).icon,
                                    color: leading != null &&
                                            leading is Icon &&
                                            (leading as Icon).color != null
                                        ? (leading as Icon).color!
                                        : Theme.of(context)
                                            .colorScheme
                                            .accentForeground)
                                : leading,
                      ),
                      title: title ?? Text(titleText ?? ''),
                      subtitle: subtitle == null && subtitleText == null
                          ? null
                          : subtitle ?? Text(subtitleText ?? ''),
                      trailing: trailing,
                      onPressed: onPressed,
                    ),
                  ),
                )
              : ListTile(
                  leading: width > leadingThreshold || essentialLeading
                      ? leading ??
                          (leadingIcon != null ? Icon(leadingIcon) : null)
                      : null,
                  title: title ?? Text(titleText ?? ''),
                  subtitle: subtitle == null && subtitleText == null
                      ? null
                      : subtitle ?? Text(subtitleText ?? ''),
                  trailing: width > trailingThreshold || essentialTrailing
                      ? trailing
                      : null,
                  onPressed: onPressed,
                ),
        )).blurIn;
  }
}
