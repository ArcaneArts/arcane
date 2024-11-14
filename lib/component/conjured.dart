import 'package:arcane/arcane.dart';

class CTitle<T extends ConjuredTitle> extends StatelessWidget {
  final T model;

  const CTitle({super.key, required this.model});

  @override
  Widget build(BuildContext context) => Text(model.title ?? "");
}

class CSubtitle<T extends ConjuredSubtitle> extends StatelessWidget {
  final T model;

  const CSubtitle({super.key, required this.model});

  @override
  Widget build(BuildContext context) => Text(model.subtitle ?? "");
}

class CBasic<T extends Conjured> extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? content;
  final Widget? trailing;
  final AlignmentGeometry? leadingAlignment;
  final AlignmentGeometry? trailingAlignment;
  final AlignmentGeometry? titleAlignment;
  final AlignmentGeometry? subtitleAlignment;
  final AlignmentGeometry? contentAlignment;
  final double? contentSpacing;
  final double? titleSpacing;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final T model;

  const CBasic({
    super.key,
    required this.model,
    this.leading,
    this.title,
    this.subtitle,
    this.content,
    this.trailing,
    this.leadingAlignment,
    this.trailingAlignment,
    this.titleAlignment,
    this.subtitleAlignment,
    this.contentAlignment,
    this.contentSpacing, // 16
    this.titleSpacing, //4
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => Basic(
        trailing: trailing,
        content: content,
        trailingAlignment: trailingAlignment,
        titleSpacing: titleSpacing,
        titleAlignment: titleAlignment,
        subtitleAlignment: subtitleAlignment,
        mainAxisAlignment: mainAxisAlignment,
        leadingAlignment: leadingAlignment,
        contentSpacing: contentSpacing,
        contentAlignment: contentAlignment,
        padding: padding,
        leading: leading,
        title: title ??
            (model is ConjuredTitle
                ? CTitle(model: model as ConjuredTitle)
                : null),
        subtitle: subtitle ??
            (model is ConjuredSubtitle
                ? CSubtitle(model: model as ConjuredSubtitle)
                : null),
      );
}

class CCard<T extends Conjured> extends StatelessWidget {
  final T model;
  final VoidCallback? onPressed;

  const CCard({super.key, required this.model, this.onPressed});

  @override
  Widget build(BuildContext context) => Card(
        onPressed: onPressed,
        child: CBasic(
          model: model,
        ),
      );
}

class CListTile<T extends Conjured> extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final T model;
  final VoidCallback? onPressed;

  const CListTile(
      {super.key,
      required this.model,
      this.onPressed,
      this.leading,
      this.trailing});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: leading,
        trailing: trailing,
        onPressed: onPressed,
        title: model is ConjuredTitle
            ? CTitle(model: model as ConjuredTitle)
            : null,
        subtitle: model is ConjuredSubtitle
            ? CSubtitle(model: model as ConjuredSubtitle)
            : null,
      );
}
