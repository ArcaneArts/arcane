import 'dart:math';

import 'package:arcane/arcane.dart';

class HomeScreen extends StatelessWidget with ArcaneRoute {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => ArcaneScreen(
        header: Bar(
          titleText: "Test",
          trailing: [
            IconButton(
                icon: Icon(Icons.airplane),
                onPressed: () => Arcane.push(context, AScreen()))
          ],
        ),
        child: Collection(
          children: [
            Text("A"),
            Text("B"),
            Text("C"),
            Section(
              child: Collection(
                children: [
                  Text("A"),
                  Text("B"),
                  Text("C"),
                ],
              ),
              titleText: "Title",
            )
          ],
        ),
      );

  @override
  String get path => "/";
}

class AScreen extends StatelessWidget with ArcaneRoute {
  const AScreen({super.key});

  @override
  Widget build(BuildContext context) => ArcaneScreen(child: Text("Hello"));

  @override
  String get path => "/ascreen";
}

class A404Screen extends StatelessWidget with ArcaneRoute {
  const A404Screen({super.key});

  @override
  Widget build(BuildContext context) => ArcaneScreen(child: Text("404 thing"));

  @override
  String get path => "/404";

  @override
  bool get is404Route => true;
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
  Widget get messageWidget => Text(message);
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
      MyMessage(
        id: Random.secure().nextDouble().toString(),
        senderId: "1",
        message: "Thingy $message",
        timestamp: DateTime.timestamp(),
      ),
    ]);
  }
}
