import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:example_routing/models.dart';

final List<NoteUser> _dbUsers = [NoteUser(name: "Dan", id: "123")];
final Map<String, BehaviorSubject<List<NoteData>>> _dbNotes = {
  "123": BehaviorSubject.seeded([
    NoteData(title: "A", content: "a", id: "n1"),
    NoteData(title: "B", content: "b", id: "n2"),
    NoteData(title: "C", content: "c", id: "n3"),
  ]),
};

class DB {
  static Future<void> _simNetLatency() =>
      Future.delayed(Duration(milliseconds: 25 + Random().nextInt(200)));

  static Future<void> deleteNote(String uid, String nid) async {
    await _simNetLatency();
    _dbNotes[uid] ??= BehaviorSubject.seeded([]);
    _dbNotes[uid]!.add(_dbNotes[uid]!.value.where((e) => e.id != nid).toList());
  }

  static Future<NoteData> createNote(String uid, String nid) async {
    await _simNetLatency();
    _dbNotes[uid] ??= BehaviorSubject.seeded([]);
    final note = NoteData(title: "Note $nid", content: "Content $nid", id: nid);
    _dbNotes[uid]!.add([..._dbNotes[uid]!.value, note]);
    return note;
  }

  static Future<NoteData> getNote(String uid, String nid) async {
    await _simNetLatency();
    return _dbNotes[uid]!.value.select((e) => e.id == nid)!;
  }

  static Stream<List<NoteData>> streamNotes(String userId) async* {
    await _simNetLatency();
    _dbNotes[userId] ??= BehaviorSubject.seeded([]);
    yield* _dbNotes[userId]!.stream;
  }

  static Future<NoteUser> getOrCreateUser(String id) =>
      _simNetLatency().then((_) {
        NoteUser? nu = _dbUsers.select((e) => e.id == id);

        if (nu == null) {
          nu = NoteUser(name: "User $id", id: id);
          _dbUsers.add(nu);
        }

        return nu;
      });
}
