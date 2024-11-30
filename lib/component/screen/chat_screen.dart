import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

enum ChatStyle {
  tiles,
  bubbles,
}

abstract class AbstractChatUser {
  String get name;
  String get id;
  Widget get avatar;
}

abstract class AbstractChatMessage {
  Widget get messageWidget;
  String get senderId;
  DateTime get timestamp;
  String get id;
}

abstract class ChatProvider {
  Stream<List<AbstractChatMessage>> streamLastMessages();

  Future<AbstractChatUser> getUser(String id);

  Future<void> sendMessage(String message);
}

class ChatScreen extends StatefulWidget {
  final bool gutter;
  final ChatStyle style;
  final ChatProvider provider;
  final String sender;
  final int? streamBuffer;
  final String placeholder;
  final Widget? header;
  final Widget? fab;
  final CrossAxisAlignment avatarAlignment;
  final int? maxMessageLength;
  final Iterable<MenuItem> Function(AbstractChatMessage message)? onMessageMenu;
  final ValueChanged<AbstractChatMessage>? onMessageTap;

  const ChatScreen(
      {super.key,
      this.fab,
      this.maxMessageLength,
      this.gutter = false,
      this.header,
      this.avatarAlignment = CrossAxisAlignment.start,
      this.placeholder = "Send a message",
      this.streamBuffer,
      this.style = ChatStyle.bubbles,
      this.onMessageMenu,
      this.onMessageTap,
      required this.provider,
      required this.sender});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late ScrollController scrollController;
  late TextEditingController chatBoxController;
  late FocusNode chatBoxFocus;
  late Map<String, AbstractChatUser> userCache;
  late Map<String, GlobalKey> messageKeys;
  late BehaviorSubject<List<AbstractChatMessage>> messageBuffer;
  late StreamSubscription<List<AbstractChatMessage>> messageSubscription;

  @override
  void initState() {
    scrollController = ScrollController();
    chatBoxFocus = FocusNode();
    chatBoxController = TextEditingController();
    userCache = {};
    messageKeys = {};
    messageBuffer = BehaviorSubject.seeded([]);
    messageSubscription =
        widget.provider.streamLastMessages().listen(updateMessageBuffer);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    chatBoxController.dispose();
    chatBoxFocus.dispose();
    messageBuffer.close();
    messageSubscription.cancel();
    super.dispose();
  }

  void updateMessageBuffer(List<AbstractChatMessage> messages) {
    String lastAddedId =
        messageBuffer.value.isNotEmpty ? messageBuffer.value.last.id : "";
    Map<String, AbstractChatMessage> messageMap = {};
    for (var message in messageBuffer.value) {
      messageMap[message.id] = message;
    }

    for (var message in messages) {
      messageMap[message.id] = message;
    }

    messageBuffer.add(
        messageMap.values.sorted((a, b) => a.timestamp.compareTo(b.timestamp)));

    String lia =
        messageBuffer.value.isNotEmpty ? messageBuffer.value.last.id : "";

    if (lastAddedId != lia) {
      bool self = messageBuffer.value.last.senderId == widget.sender;
      bool mostlyDown = scrollController.position.maxScrollExtent -
              scrollController.position.pixels <
          250;

      if (mostlyDown || self) {
        Future.delayed(16.ms, () async {
          int g = 5;
          while (g-- > 0 &&
              scrollController.position.pixels <
                  scrollController.position.maxScrollExtent) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
            await Future.delayed(Duration(milliseconds: 16));
          }
        });
      }
    }
  }

  Future<AbstractChatUser> getUser(String id) async {
    if (userCache.containsKey(id)) {
      return userCache[id]!;
    }

    final user = await widget.provider.getUser(id);
    userCache[id] = user;
    return user;
  }

  Widget buildUserAvatar(String id) => FutureBuilder<AbstractChatUser>(
      future: getUser(id),
      builder: (context, snap) =>
          snap.hasData ? snap.data!.avatar : const SizedBox.shrink());

  Widget buildUserHeader(String id) => FutureBuilder<AbstractChatUser>(
      future: getUser(id),
      builder: (context, snap) =>
          snap.hasData ? Text(snap.data!.name) : const SizedBox.shrink());

  GlobalKey getMessageKey(String id) {
    if (messageKeys.containsKey(id)) {
      return messageKeys[id]!;
    }

    final key = GlobalKey();
    messageKeys[id] = key;
    return key;
  }

  Widget buildMessage(BuildContext context, AbstractChatMessage message) =>
      Pylon<AbstractChatMessage>(
          value: message,
          local: true,
          builder: (context) => Stack(
                children: [
                  Visibility(visible: false, child: ChatMessageView()),
                  ChatMessageView()
                      .animate(
                        key: getMessageKey(message.id),
                        delay: 50.ms,
                      )
                      .fadeIn(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutExpo,
                      )
                      .blurXY(
                        begin: 36,
                        end: 0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCirc,
                      )
                ],
              ));

  void send(String v) {
    if (v.trim().isEmpty) return;
    chatBoxController.clear();
    widget.provider.sendMessage(v);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => chatBoxFocus.requestFocus());
  }

  @override
  Widget build(BuildContext context) => PylonCluster(
        pylons: [
          Pylon<ChatStyle>.data(value: widget.style, local: true),
          Pylon<ChatScreenState>.data(value: this, local: true),
        ],
        builder: (context) => SliverScreen(
            header: widget.header,
            fab: widget.fab,
            gutter: widget.gutter,
            scrollController: scrollController,
            footer: const ChatBox(
              key: ValueKey("ChatBox"),
            ),
            sliver: messageBuffer.buildNullable((messages) => SListView.builder(
                  addAutomaticKeepAlives: true,
                  childCount: messages?.length ?? 0,
                  builder: (context, index) =>
                      buildMessage(context, messages![index]),
                ))),
      );
}

class ChatBox extends StatelessWidget {
  const ChatBox({super.key});

  @override
  Widget build(BuildContext context) {
    ChatScreenState state = context.pylon<ChatScreenState>();
    return SurfaceCard(
        borderRadius: BorderRadius.only(
          topLeft: Theme.of(context).radiusXlRadius,
          topRight: Theme.of(context).radiusXlRadius,
        ),
        padding: const EdgeInsets.all(8),
        child: TextField(
          maxLength: state.widget.maxMessageLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          autofocus: true,
          border: false,
          controller: state.chatBoxController,
          focusNode: state.chatBoxFocus,
          onSubmitted: state.send,
          placeholder: state.widget.placeholder,
          trailing: IconButton(
            icon: const Icon(Icons.send_ionic),
            onPressed: () => state.send(state.chatBoxController.text),
          ),
        ));
  }
}

class ChatMessageView extends StatefulWidget {
  const ChatMessageView({super.key});

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (context.pylonOr<ChatStyle>() ?? ChatStyle.bubbles) ==
            ChatStyle.bubbles
        ? ChatMessageBubble()
        : ChatMessageTile();
  }

  @override
  bool get wantKeepAlive => true;
}

class ChatMessageTile extends StatelessWidget {
  const ChatMessageTile({super.key});

  @override
  Widget build(BuildContext context) {
    ChatScreenState state = context.pylon<ChatScreenState>();
    AbstractChatMessage message = context.pylon<AbstractChatMessage>();
    Widget avatar = state.buildUserAvatar(message.senderId);
    Widget header = state.buildUserHeader(message.senderId);
    Widget child = message.messageWidget;
    List<MenuItem>? contextMenu =
        state.widget.onMessageMenu?.call(message).toList();
    contextMenu = (contextMenu?.isEmpty ?? true) ? null : contextMenu;
    ValueChanged<AbstractChatMessage>? onPressed = state.widget.onMessageTap;

    return ContextMenu(
        enabled: contextMenu != null && contextMenu!.isNotEmpty,
        items: contextMenu ?? const [],
        child: Clickable(
            onPressed: onPressed != null ? () => onPressed(message) : null,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: state.widget.avatarAlignment,
              children: [
                Gap(8),
                avatar.padOnly(top: 8, bottom: 8),
                Gap(8),
                Flexible(
                    child: Basic(
                  title: header,
                  subtitle: child,
                )),
                Gap(8),
              ],
            ).padOnly(
              top: 8,
              bottom: 8,
            )));
  }
}

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    ChatScreenState state = context.pylon<ChatScreenState>();
    AbstractChatMessage message = context.pylon<AbstractChatMessage>();
    Widget avatar = state.buildUserAvatar(message.senderId);
    Widget child = message.messageWidget;
    bool sender = message.senderId == state.widget.sender;
    List<MenuItem>? contextMenu =
        state.widget.onMessageMenu?.call(message).toList();
    contextMenu = (contextMenu?.isEmpty ?? true) ? null : contextMenu;
    ValueChanged<AbstractChatMessage>? onPressed = state.widget.onMessageTap;

    return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            child: Row(
              crossAxisAlignment: state.widget.avatarAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!sender) ...[avatar.padOnly(top: 8, bottom: 8), Gap(8)],
                Flexible(
                    child: ContextMenu(
                        enabled: contextMenu != null && contextMenu.isNotEmpty,
                        items: contextMenu ?? const [],
                        child: Card(
                          onPressed: onPressed != null
                              ? () => onPressed(message)
                              : null,
                          borderWidth: 0,
                          borderColor: Colors.transparent,
                          padding: const EdgeInsets.all(8),
                          filled: true,
                          fillColor: sender
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          child: sender ? child.primaryForeground() : child,
                        ))),
                if (sender) ...[
                  Gap(8),
                  avatar.padOnly(top: 8, bottom: 8),
                ],
              ],
            ).iw)
        .withAlign(sender ? Alignment.centerRight : Alignment.centerLeft)
        .pad(8);
  }
}

class ChatDivider extends StatelessWidget {
  final Widget? child;
  final Color? color;

  const ChatDivider({super.key, this.child, this.color});

  @override
  Widget build(BuildContext context) =>
      Divider(color: color, child: child).padOnly(top: 8, bottom: 8);
}
