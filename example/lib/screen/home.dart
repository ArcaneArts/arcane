import 'package:arcane/arcane.dart';

List<String> list = List.generate(5, (index) => "Item $index");

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BehaviorSubject<List<Person>> persons = BehaviorSubject<List<Person>>.seeded([
    Person(id: "1", name: "Daniel Mills", email: "dan@arcane.art", phone: "no"),
    Person(id: "2", name: "John Doe", email: "john@arcane.art", phone: "no"),
    Person(id: "3", name: "Jane Doe", email: "jane@arcane.art", phone: "no"),
    Person(
        id: "4", name: "Kevin Smith", email: "kevin@arcane.art", phone: "no"),
  ]);

  @override
  Widget build(BuildContext context) => CollectionScreen<Person>(
      onLoadMore: (a, b, c, d) async {
        await Future.delayed(Duration(seconds: 1));
        persons.add([
          ...persons.value,
          ...List.generate(
              20,
              (_) => Person(
                  id: Uuid().v4(),
                  name: "Random ${Uuid().v4()}",
                  email: "Scroll loaded",
                  phone: "no"))
        ]);

        return true;
      },
      data: persons,
      itemBuilder: (p) => ListTile(
            title: Text(p.name),
            subtitle: Text(p.email),
            leading: const Icon(Icons.user),
          ),
      typeName: "Person",
      typeNamePlural: "People");
}

class Person {
  final String id;
  final String name;
  final String email;
  final String phone;

  Person(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
      };
}
