import 'dart:io';
import 'dart:math';

import 'package:arcane/arcane.dart';

bool v = false;
String? vv;
void main() {
  runApp(const ExampleArcaneApp());
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  @override
  Widget build(BuildContext context) => ArcaneApp(
        home: ExampleNavigationScreen(),
        theme: ArcaneTheme(
            scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc)),
      );
}

VFS _vfs = IOVFS(Directory("${Directory.current.absolute.path}/build/iovfs"));

ChatProvider provider = MyChatProvider(users: [
  MyUser(id: "0", name: "Dan"),
  MyUser(id: "1", name: "Alice"),
  MyUser(id: "2", name: "Bob"),
  MyUser(id: "3", name: "Charlie"),
], messages: BehaviorSubject.seeded([]));

class ExampleNavigationScreen extends StatelessWidget {
  const ExampleNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) => ChatScreen(
      gutter: false,
      header: const Bar(titleText: "Chat Tiles"),
      style: ChatStyle.bubbles,
      provider: provider,
      sender: "0");
}

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
  Future<void> sendMessage(String message) {
    messages.add([
      ...messages.value,
      MyMessage(
        id: Random.secure().nextDouble().toString(),
        senderId: "0",
        message: message,
        timestamp: DateTime.timestamp(),
      ),
    ]);

    if (Random.secure().nextBool()) {
      messages.add([
        ...messages.value,
        MyMessage(
          id: Random.secure().nextDouble().toString(),
          senderId: "1",
          message: "Well well well",
          timestamp: DateTime.timestamp(),
        ),
      ]);

      if (Random.secure().nextBool()) {
        messages.add([
          ...messages.value,
          MyMessage(
            id: Random.secure().nextDouble().toString(),
            senderId: "1",
            message: "Well well well woah woah",
            timestamp: DateTime.timestamp(),
          ),
        ]);

        if (Random.secure().nextBool()) {
          messages.add([
            ...messages.value,
            MyMessage(
              id: Random.secure().nextDouble().toString(),
              senderId: "1",
              message: "NICE!",
              timestamp: DateTime.timestamp(),
            ),
          ]);
        }
      }
    }

    return Future.value();
  }
}

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

  @override
  Widget get messageWidget => Text(message);
}

class MyUser extends AbstractChatUser {
  @override
  final String id;
  @override
  final String name;

  MyUser({
    required this.id,
    required this.name,
  });

  @override
  Widget get avatar => const Icon(Icons.user);
}
