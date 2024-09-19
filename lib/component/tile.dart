import 'package:arcane/arcane.dart';

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
  final ValueChanged<bool>? onChanged;

  const CheckboxTile({
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

  Widget buildCheckbox(
    BuildContext context, {
    Widget? leading,
    Widget? trailing,
  }) =>
      ArcaneCheckbox(
        leading: leading,
        trailing: trailing,
        state: (value ?? false)
            ? ArcaneCheckboxState.unchecked
            : ArcaneCheckboxState.checked,
        onChanged: (v) =>
            onChanged != null ? onChanged!(v == CheckboxState.checked) : null,
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
  });

  Widget get styledSubtitle =>
      subtitle is Text ? subtitle!.small().muted() : subtitle!;

  Widget get styledTitle => title is Text ? title!.medium() : title!;

  Widget buildTile(BuildContext context) => Padding(
      padding: contentPadding,
      child: true
          ? Row(
              children: [
                Expanded(
                    child: Basic(
                  leadingAlignment: Alignment.center,
                  trailingAlignment: Alignment.center,
                  leading: leading,
                  trailing: trailing,
                  title: title,
                  subtitle: subtitle,
                ))
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null)
                  Padding(
                    padding: leadingPadding,
                    child: leading!,
                  ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) styledTitle,
                    if (subtitle != null) styledSubtitle,
                  ],
                )),
                if (trailing != null)
                  Padding(
                    padding: leadingPadding,
                    child: trailing!,
                  )
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
  Widget build(BuildContext context) => sliver
      ? buildSliver(context)
      : onPressed != null
          ? GhostButton(
              onPressed: onPressed,
              density: ButtonDensity.compact,
              child: buildTile(context))
          : buildTile(context);
}
