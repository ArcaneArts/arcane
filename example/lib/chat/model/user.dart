import 'package:arcane/arcane.dart';

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
