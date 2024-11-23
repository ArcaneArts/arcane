import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:example/chat/model/message.dart';
import 'package:example/chat/model/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

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
        id: const Uuid().v4(),
        senderId: "0",
        message: message,
        timestamp: DateTime.timestamp(),
      ),
    ]);

    if (Random.secure().nextBool()) {
      messages.add([
        ...messages.value,
        MyMessage(
          id: const Uuid().v4(),
          senderId: "1",
          message: "Well well well",
          timestamp: DateTime.timestamp(),
        ),
      ]);

      if (Random.secure().nextBool()) {
        messages.add([
          ...messages.value,
          MyMessage(
            id: const Uuid().v4(),
            senderId: "1",
            message: "Well well well woah woah",
            timestamp: DateTime.timestamp(),
          ),
        ]);

        if (Random.secure().nextBool()) {
          messages.add([
            ...messages.value,
            MyMessage(
              id: const Uuid().v4(),
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
