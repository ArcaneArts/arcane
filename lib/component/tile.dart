import 'package:arcane/arcane.dart';
import 'package:faker/faker.dart';

typedef ListTile = Tile;
typedef SwitchListTile = SwitchTile;
typedef CheckboxListTile = CheckboxTile;

enum TileWidgetPosition { leading, trailing }

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

  const CheckboxTile({
    super.key,
    this.checkPosition = TileWidgetPosition.trailing,
    this.title,
    this.subtitle,
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

  @override
  Widget build(BuildContext context) => Tile(
        title: title,
        subtitle: subtitle,
        leading: checkPosition == TileWidgetPosition.leading
            ? buildCheckbox(context, leading: leading)
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

class Tile extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
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

  const Tile({
    super.key,
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
      padding: contentPadding,
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
            title: title,
            subtitle: subtitle,
          ))
        ],
      ));

  Widget buildSliver(BuildContext context) => GlassSection(
      header: Padding(
          padding: contentPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null)
                Padding(
                  padding: EdgeInsets.only(right: leadingPadding.right),
                  child: leading!,
                ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    DefaultTextStyle(
                        style: Theme.of(context).typography.medium.copyWith(
                            color: Theme.of(context).colorScheme.foreground),
                        child: title!),
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
                    (leading != null
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
                    if (subtitle != null)
                      DefaultTextStyle(
                              style: Theme.of(context)
                                  .typography
                                  .small
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .foreground),
                              child: subtitle!)
                          .withOpacity(0.9),
                  ],
                ))
              ],
            )),
      ));

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
