import 'package:arcane/arcane.dart';

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
        const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
    this.leadingPadding = const EdgeInsets.only(right: 10, top: 4),
    this.trailingPadding = const EdgeInsets.only(left: 10, top: 4),
    this.sliver = false,
  });

  Widget buildTile(BuildContext context) => Padding(
      padding: contentPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              if (title != null)
                DefaultTextStyle(
                    style: Theme.of(context).typography.medium, child: title!),
              if (subtitle != null)
                DefaultTextStyle(
                    style: Theme.of(context).typography.xSmall,
                    child: subtitle!),
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
                        style: Theme.of(context).typography.medium,
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
                              style: Theme.of(context).typography.xSmall,
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
