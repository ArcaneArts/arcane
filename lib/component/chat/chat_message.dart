import 'package:arcane/arcane.dart';

class ChatBubble extends StatelessWidget {
  final Widget content;
  final Widget? header;
  final Widget? footer;
  final Widget? leading;
  final Widget? trailing;
  final bool altColor;

  const ChatBubble({
    super.key,
    required this.content,
    this.footer,
    this.header,
    this.leading,
    this.trailing,
    this.altColor = false,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!.padTop((header != null ? 16 : 0) + 16),
            Gap(8),
          ],
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (header != null) ...[
                header!.xSmall.muted.padLeft(4),
                Gap(4),
              ],
              Flexible(
                  child: Card(
                child: content,
                borderColor: altColor ? null : null,
                fillColor:
                    altColor ? Theme.of(context).colorScheme.muted : null,
                filled: altColor,
              )),
              if (footer != null) ...[
                Gap(4),
                footer!.xSmall.muted.padLeft(4),
              ]
            ],
          ),
          if (trailing != null) ...[
            Gap(8),
            trailing!.padTop((header != null ? 16 : 0) + 16),
          ],
        ],
      );
}
