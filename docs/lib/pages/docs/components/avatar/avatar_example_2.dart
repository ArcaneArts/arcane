import 'package:arcane/arcane.dart';

class AvatarExample2 extends StatelessWidget {
  const AvatarExample2({super.key});

  @override
  Widget build(BuildContext context) {
    return Avatar(
      initials: Avatar.getInitials('sunarya-thito'),
      size: 64,
    );
  }
}
