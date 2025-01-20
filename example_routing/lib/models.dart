import 'package:arcane/arcane.dart';
import 'package:example_routing/db.dart';

class NoteUser {
  final String name;
  final String id;

  NoteUser({required this.name, required this.id});

  NoteUser.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      id = json['id'];

  Map<String, dynamic> toJson() => {'name': name, 'id': id};

  NoteUser copyWith({String? name, String? id}) {
    return NoteUser(name: name ?? this.name, id: id ?? this.id);
  }
}

class NoteData implements PylonCodec<NoteData> {
  final String title;
  final String content;
  final String id;

  NoteData({required this.title, required this.content, required this.id});

  NoteData.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      content = json['content'],
      id = json['id'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'id': id,
  };

  NoteData copyWith({String? title, String? content, String? id}) {
    return NoteData(
      title: title ?? this.title,
      content: content ?? this.content,
      id: id ?? this.id,
    );
  }

  @override
  Future<NoteData> pylonDecode(String value) {
    print(
      "WE HAVE TO DECODE $value into a note object because we dont have it panik!!!",
    );
    return DB.getNote("123", value);
  }

  @override
  String pylonEncode(NoteData value) => value.id;
}

extension XContext on BuildContext {
  NoteUser get user => pylon<NoteUser>();

  NoteData get note => pylon<NoteData>();
}
