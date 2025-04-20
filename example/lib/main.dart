import 'dart:async';
import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

bool v = false;
String? vv;
void main() {
  runZonedGuarded(() {
    runApp("example", const ExampleArcaneApp());
  }, (error, stackTrace) {
    print("Error: $error");
    print("Stack: $stackTrace");
  });
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  void didShortcut() {
    print("YOU DID IT");
  }

  @override
  Widget build(BuildContext context) => ArcaneShortcuts(
          shortcuts: {
            LogicalKeySet(
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.alt,
              LogicalKeyboardKey.keyF,
            ): didShortcut
          },
          child: ArcaneApp(
            home: HomeScreen(),
            showPerformanceOverlay: false,
            theme: ArcaneTheme(
                themeMode: ThemeMode.system,
                scheme: ContrastedColorScheme.fromScheme(ColorSchemes.violet)),
          ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatScreen(
        gutter: false,
        header: const Bar(titleText: "Chat Bubbles"),
        style: ChatStyle.bubbles,
        provider: MyChatProvider(users: [
          MyUser(id: "0", name: "Dan"),
          MyUser(id: "1", name: "Alice"),
          MyUser(id: "2", name: "Bob"),
          MyUser(id: "3", name: "Charlie"),
        ], messages: BehaviorSubject.seeded([])),
        sender: "0");
  }
}

/// Define a message model and implement AbstractChatMessage
class MyMessage implements AbstractChatMessage {
  final String id;
  final String message;
  @override
  final DateTime timestamp;
  @override
  final String senderId;

  MyMessage({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.senderId,
  });

  /// Build the content for the message
  @override
  Widget get messageWidget => Markdown(message);
}

/// Define a user model and implement AbstractChatUser
class MyUser extends AbstractChatUser {
  @override
  final String id;
  @override
  final String name;

  MyUser({
    required this.id,
    required this.name,
  });

  /// Build the avatar for the user
  @override
  Widget get avatar => const Icon(Icons.user);
}

// You need a Provider that extends ChatProvider to handle messages
class MyChatProvider extends ChatProvider {
  final List<MyUser> users;
  final BehaviorSubject<List<MyMessage>> messages;

  MyChatProvider({
    required this.users,
    required this.messages,
  });

  @override
  Future<MyUser> getUser(String id) async =>
      users.firstWhere((element) => element.id == id);

  @override
  Stream<List<MyMessage>> streamLastMessages() => messages;

  @override
  Future<void> sendMessage(String message) async {
    messages.add([
      ...messages.value,
      MyMessage(
        id: Random.secure().nextDouble().toString(),
        senderId: "0",
        message: message,
        timestamp: DateTime.timestamp(),
      ),
    ]);
  }
}
