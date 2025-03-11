import 'package:arcane/arcane.dart';

/// A widget that displays the title from a model implementing [ConjuredTitle].
///
/// Part of the Conjured component system, which provides utility widgets for
/// displaying data models that implement the [Conjured] interface with minimal boilerplate.
///
/// See also:
///  * [doc/component/conjured.md] for more detailed documentation
///  * [CSubtitle], which displays subtitles from models
///  * [CBasic], which provides a structured layout for Conjured models
class CTitle<T extends ConjuredTitle> extends StatelessWidget {
  /// The model containing the title to display.
  final T model;

  /// Creates a [CTitle] widget.
  ///
  /// The [model] parameter must implement [ConjuredTitle] and is used
  /// to retrieve the title text to display.
  const CTitle({super.key, required this.model});

  @override
  Widget build(BuildContext context) => Text(model.title ?? "");
}

/// A widget that displays the subtitle from a model implementing [ConjuredSubtitle].
///
/// Part of the Conjured component system for displaying data models consistently.
///
/// See also:
///  * [doc/component/conjured.md] for more detailed documentation
///  * [CTitle], which displays titles from models
///  * [CBasic], which provides a structured layout for Conjured models
class CSubtitle<T extends ConjuredSubtitle> extends StatelessWidget {
  /// The model containing the subtitle to display.
  final T model;

  /// Creates a [CSubtitle] widget.
  ///
  /// The [model] parameter must implement [ConjuredSubtitle] and is used
  /// to retrieve the subtitle text to display.
  const CSubtitle({super.key, required this.model});

  @override
  Widget build(BuildContext context) => Text(model.subtitle ?? "");
}

/// A structured layout component for displaying Conjured models using the [Basic] component.
///
/// [CBasic] provides a flexible layout for displaying data from models that implement
/// the [Conjured] interface. It automatically handles title and subtitle display if
/// the model implements [ConjuredTitle] or [ConjuredSubtitle].
///
/// See also:
///  * [doc/component/conjured.md] for more detailed documentation
///  * [CTitle], used internally to display titles
///  * [CSubtitle], used internally to display subtitles
///  * [Basic], which this component uses for layout
class CBasic<T extends Conjured> extends StatelessWidget {
  /// Widget to display at the start of the layout.
  final Widget? leading;
  
  /// Custom title widget. If null and the model implements [ConjuredTitle],
  /// a [CTitle] widget will be used.
  final Widget? title;
  
  /// Custom subtitle widget. If null and the model implements [ConjuredSubtitle],
  /// a [CSubtitle] widget will be used.
  final Widget? subtitle;
  
  /// Main content widget to display.
  final Widget? content;
  
  /// Widget to display at the end of the layout.
  final Widget? trailing;
  
  /// Alignment for the leading widget.
  final AlignmentGeometry? leadingAlignment;
  
  /// Alignment for the trailing widget.
  final AlignmentGeometry? trailingAlignment;
  
  /// Alignment for the title widget.
  final AlignmentGeometry? titleAlignment;
  
  /// Alignment for the subtitle widget.
  final AlignmentGeometry? subtitleAlignment;
  
  /// Alignment for the content widget.
  final AlignmentGeometry? contentAlignment;
  
  /// Space between content and title/subtitle.
  final double? contentSpacing;
  
  /// Space between title and subtitle.
  final double? titleSpacing;
  
  /// Main axis alignment for the layout.
  final MainAxisAlignment mainAxisAlignment;
  
  /// Padding around the entire component.
  final EdgeInsetsGeometry? padding;
  
  /// The model to display.
  final T model;

  /// Creates a [CBasic] widget for displaying a Conjured model.
  ///
  /// The [model] parameter is required and must implement [Conjured].
  /// Other parameters allow customizing the layout and appearance of the component.
  ///
  /// If [title] is null and [model] implements [ConjuredTitle], a [CTitle] widget
  /// will be used to display the title.
  ///
  /// If [subtitle] is null and [model] implements [ConjuredSubtitle], a [CSubtitle] widget
  /// will be used to display the subtitle.
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

/// A widget that wraps a Conjured model in a [Card] component.
///
/// [CCard] provides a convenient way to display a Conjured model within a card,
/// with optional tap behavior.
///
/// See also:
///  * [doc/component/conjured.md] for more detailed documentation
///  * [CBasic], which is used internally to display the model
///  * [Card], which this component uses as a container
class CCard<T extends Conjured> extends StatelessWidget {
  /// The model to display in the card.
  final T model;
  
  /// Function to call when the card is tapped.
  final VoidCallback? onPressed;

  /// Creates a [CCard] widget.
  ///
  /// The [model] parameter is required and must implement [Conjured].
  /// The [onPressed] parameter is optional and will be called when the card is tapped.
  ///
  /// Example:
  /// ```dart
  /// CCard(
  ///   model: User(name: "John Doe", email: "john@example.com"),
  ///   onPressed: () => print("Card tapped"),
  /// )
  /// ```
  const CCard({super.key, required this.model, this.onPressed});

  @override
  Widget build(BuildContext context) => Card(
        onPressed: onPressed,
        child: CBasic(
          model: model,
        ),
      );
}

/// A widget that displays a Conjured model as a list tile.
///
/// [CListTile] adapts a Conjured model to be displayed in a list tile format,
/// with optional leading and trailing widgets.
///
/// See also:
///  * [doc/component/conjured.md] for more detailed documentation
///  * [ListTile], which this component uses as its base
class CListTile<T extends Conjured> extends StatelessWidget {
  /// Widget to display at the start of the tile.
  final Widget? leading;
  
  /// Widget to display at the end of the tile.
  final Widget? trailing;
  
  /// The model to display in the list tile.
  final T model;
  
  /// Function to call when the tile is tapped.
  final VoidCallback? onPressed;

  /// Creates a [CListTile] widget.
  ///
  /// The [model] parameter is required and must implement [Conjured].
  /// The [onPressed] parameter is optional and will be called when the tile is tapped.
  /// The [leading] and [trailing] parameters are optional widgets to display at the
  /// start and end of the tile.
  ///
  /// Example:
  /// ```dart
  /// CListTile(
  ///   model: User(name: "John Doe", email: "john@example.com"),
  ///   leading: CircleAvatar(child: Text("JD")),
  ///   trailing: Icon(Icons.chevron_right),
  ///   onPressed: () => print("Tile tapped"),
  /// )
  /// ```
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
