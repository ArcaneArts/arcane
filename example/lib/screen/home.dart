import 'dart:math';

import 'package:arcane/arcane.dart';

class HomeScreen extends StatelessWidget with ArcaneRoute {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => NavigationScreen(tabs: [
        NavTab(
            icon: Icons.airplane,
            builder: (context) => SliverScreen(
                header: Bar(titleText: "---"),
                sliver: MultiSliver(
                  children: [
                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        height: 5,
                        color: Colors.red,
                      ),
                    ),
                    BarSection(
                        titleText: "Chat",
                        sliver: SListView.builder(
                            childCount: 10,
                            builder: (context, i) => ListTile(
                                  title: Text("A$i"),
                                ))),
                    BarSection(
                        titleText: "Chat",
                        sliver: SListView.builder(
                            childCount: 10,
                            builder: (context, i) => ListTile(
                                  title: Text("A$i"),
                                ))),
                    BarSection(
                        titleText: "Chat",
                        sliver: SListView.builder(
                            childCount: 10,
                            builder: (context, i) => ListTile(
                                  title: Text("A$i"),
                                ))),
                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        height: 5,
                        color: Colors.red,
                      ),
                    ),
                    BarSection(
                        titleText: "Chat",
                        sliver: SListView.builder(
                            childCount: 10,
                            builder: (context, i) => ListTile(
                                  title: Text("A$i"),
                                )))
                  ],
                )))
      ], type: NavigationType.sidebar);

  @override
  String get path => "/";
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
