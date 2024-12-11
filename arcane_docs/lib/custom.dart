import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:arcane/component/dialog/command.dart';
import 'package:docs/pages/docs_page.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh hide TextExtension;

late BuildContext _context;

List<ShadcnDocsSection> customSections = [
  ShadcnDocsSection("Arcane", [
    ShadcnDocsPage("Screens", "screens"),
    ShadcnDocsPage("Routing", "routing"),
    ShadcnDocsPage("Chat", "chat"),
    ShadcnDocsPage("Static Table", "static_table"),
    ShadcnDocsPage("Dialogs", "dialogs"),
    ShadcnDocsPage("Search", "search"),
    ShadcnDocsPage("Image", "image"),
    ShadcnDocsPage("Center Body", "center_body"),
  ])
];

//////////////////////////////////////////////////////////////////////////////////////////
List<GoRoute> customRoutes = [
  GoRoute(
      path: "search",
      name: "search",
      builder: (_, __) => ArcaneComponentPage(
            name: 'search',
            description: 'Helpful Widgets for making search easier',
            displayName: 'Search',
            children: [
              exampleSearchBox,
              exampleSearchButtonTransactional,
              exampleSearchButtonLive,
            ],
          )),
  GoRoute(
      path: "screens",
      name: "screens",
      builder: (_, __) => ArcaneComponentPage(
            name: 'screens',
            description:
                'Arcane screens allow you to easily create scaffolds of various types & uses.',
            displayName: 'Screens',
            children: [
              exampleScreenFill,
              exampleScreenSliver,
              exampleScreenSliverSections,
              exampleScreenNavigation
            ],
          )),
  GoRoute(
      path: "routing",
      name: "routing",
      builder: (_, __) => ArcaneComponentPage(
            name: 'routing',
            description:
                'Arcane Routing allows you to continue pusing delcarative screens but with the benefits of path navigation.',
            displayName: 'Routing',
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectableText("Enable Path Routing").h2(),
                  Gap(4),
                  SelectableText(
                      "This is optional but it allows you to display web addresses that dont have the hash path /#/ style."),
                  Gap(4),
                  ArcaneCodeSnippetBuilder(
                    code: """
void main() {
  if (kIsWeb) {
    // Removes the /#/ from the url
    usePathUrlStrategy();
  }
  
  // continue initialization
}""",
                    mode: 'dart',
                    summarize: true,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectableText("Define Arcane Routes").h2(),
                  Gap(4),
                  SelectableText(
                      "Arcane Routes are defined in the screen class itself instead of a route mapping in the main application widget. Each screen defines a path. Typically starting with / however this can technically be /a/b/c even though it's not actually a hierarchical setup."),
                  Gap(4),
                  ArcaneCodeSnippetBuilder(
                    code: """
class HomeScreen extends StatelessWidget with ArcaneRoute {
                                 // add mixin ArcaneRoute
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => FillScreen(
    // Build any widget or screen here   
  );

  @override
  String get path => "/"; // Define path here
}""",
                    mode: 'dart',
                    summarize: true,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectableText("Reference Routes in Application").h2(),
                  Gap(4),
                  SelectableText(
                      "Once you have arcane routes defined, simply list them in your ArcaneApp so the app can route to those screens when hit with a path."),
                  Gap(4),
                  ArcaneCodeSnippetBuilder(
                    code: """
ArcaneApp(
  arcaneRoutes: [
    HomeScreen(),
    NotesScreen(),
    NoteScreen(),
  ],
  // Don't define a home, you may define an initialRoute. Defaults to "/"
  initialRoute: "/",
  ...
);""",
                    mode: 'dart',
                    summarize: true,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectableText("Pushing").h2(),
                  Gap(4),
                  SelectableText("Pushing to screens is extremely simple."),
                  Gap(4),
                  ArcaneCodeSnippetBuilder(
                    code: """
// If this screen is an ArcaneRoute, the path will be updated in the url
// Otherwise it just functions like a regular push
Arcane.push(context, NotesScreen())""",
                    mode: 'dart',
                    summarize: true,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectableText("Transferring Data via Pylon").h2(),
                  Gap(4),
                  SelectableText(
                      "If you are already using pylon, you can expose specific pylons to the browser uri & supply a codec for decoding from the url in the event the data is unavailable from a previous screen."),
                  Gap(4),
                  ArcaneCodeSnippetBuilder(
                    code: """
class NoteScreen extends StatelessWidget with ArcaneRoute {
                                // with mixin ArcaneRoute
  const NoteScreen({super.key});

  @override              // We define a PylonPort of Note
  Widget build(BuildContext context) => PylonPort<Note>(
      // Tag is the data key in the uri i.e. https://website/notes/view?note=<DATA>
      tag: "note",
      
      // A widget if the data is not available or fails to decode
      error: const FillScreen(child: Center(child: Text("Error"))),
      
      // A widget to show while the data is loading if it cant be accessed immediately
      loading: const FillScreen(
          child: Center(
        child: Text("Loading"),
      )),
      
      // A regular builder which allows you to obtain the note from context
      // PylonPort will add the decoded note if it was unavailable before calling this.
      builder: (context) => FillScreen(
          header: Bar(
            // context.note is a method extension on BuildContext 
            // Note get note => pylon<Note>();
            titleText: context.note.name,
          ),
          child: Text(context.note.description)));

  // Defining a nested path is just a name not really nested
  @override
  String get path => "/notes/view";
}
""",
                    mode: 'dart',
                    summarize: true,
                  ),
                  Gap(4),
                  SelectableText(
                      "Navigating to this screen with Arcane.push(context, NoteScreen()) will update the uri of the browser to /notes/view?note=<DATA>. Accessing this uri directly will use the pylon port to decode a note and inject it into a pylon so the note is still available."),
                  Gap(4),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectableText("Pylon Codecs").h2(),
                  Gap(4),
                  SelectableText(
                      "Because we don't want to actually encode the full data of the object into the uri, it's best to reference the data so it can be retrieved from the source."),
                  Gap(4),
                  ArcaneCodeSnippetBuilder(
                    code: """
// A note class representing our data model
class Note implements PylonCodec<Note> {
  // Implement the codec directly in your models
  final int id;
  final String name;
  final String description;
  ...

  const Note({
    required this.id,
    required this.name,
    required this.description,
    ...
  });

  Map<String, dynamic> toMap() ...

  factory Note.fromMap(Map<String, dynamic> map) ...

  @override
  // Make sure to encode VALUE.id, and not id.
  String pylonEncode(Note value) => value.id.toString();

  @override
  // This supports a future of decoding
  Future<Note> pylonDecode(String value) async => notes[int.parse(value)];
}""",
                    mode: 'dart',
                    summarize: true,
                  ),
                  Gap(4),
                  ArcaneCodeSnippetBuilder(
                    code: """
void main(){
  // register your codecs
  registerPylonCodec(const Note(id: -1, name: "", description: ""));
}""",
                    mode: 'dart',
                    summarize: true,
                  ),
                  Gap(4),
                  SelectableText(
                      "Note: If you are using fire_crud models, the pylon_codec is already included with all of your models. They use the full document path as uri data."),
                  Gap(4),
                ],
              ),
            ],
          )),
  GoRoute(
      path: "dialogs",
      name: "dialogs",
      builder: (_, __) => ArcaneComponentPage(
            name: 'dialogs',
            description:
                'Arcane dialogs are designed to be quick to use but also easy to extend.',
            displayName: 'Dialogs',
            children: [
              exampleDialogConfirm,
              exampleDialogConfirmText,
              exampleDialogText,
              exampleDialogEmail,
              exampleDialogCommand,
              exampleDialogDate,
              exampleDialogDateRange,
              exampleDialogDateMulti,
              exampleDialogTime,
            ],
          )),
  GoRoute(
      path: "center_body",
      name: "center_body",
      builder: (_, __) => ArcaneComponentPage(
            name: 'center_body',
            description:
                'Center Body is a simple widget that displays a message and an icon, optionally with an action button.',
            displayName: 'Center Body',
            children: [
              exampleCenterBodySimple,
              exampleCenterBodyAction,
            ],
          )),
  GoRoute(
      path: "image",
      name: "image",
      builder: (_, __) => ArcaneComponentPage(
            name: 'image',
            description:
                'A unified image view that supports local caching, future urls & thumbhashes/blurhashes.',
            displayName: 'Image',
            children: [exampleImage],
          )),
  GoRoute(
      path: "chat",
      name: "chat",
      builder: (_, __) => ArcaneComponentPage(
            name: 'chat',
            description: 'A chat UI that supports basic messages on a stream.',
            displayName: 'Chat',
            children: [exampleChatBubblesScreen, exampleChatTilesScreen],
          )),
  GoRoute(
      path: "static_table",
      name: "static_table",
      builder: (_, __) => ArcaneComponentPage(
            name: 'static_table',
            description:
                'Tables for Arcane are designed to be simple to use and easy to extend.',
            displayName: 'Static Table',
            children: [
              exampleTables,
              exampleTableAltColors,
              exampleTableWithColors,
              exampleTableColumnSizes
            ],
          )),
];

//////////////////////////////////////////////////////////////////////////////////////////

Widget get exampleSearchButtonTransactional => ArcaneUsageExample(
      padding: 0,
      title: 'Transactional Search Button',
      code: r"""
FillScreen(
  header: Bar(titleText: "Header", trailing: [
    SearchButton(
      mode: SearchButtonMode.transactional,
      onSearch: (v) => setState(() {
        query = v;
      }),
    )
  ]),
  child: Center(child: Text(query == null ? "null" : '"$query"'))
)
""",
      child: SizedBox(
        height: 300,
        child: SearchExample(mode: SearchButtonMode.transactional),
      ),
    );

Widget get exampleSearchButtonLive => ArcaneUsageExample(
      padding: 0,
      title: 'Live Search Button',
      code: r"""
FillScreen(
  header: Bar(titleText: "Header", trailing: [
    SearchButton(
      mode: SearchButtonMode.live,
      onSearch: (v) => setState(() {
        query = v;
      }),
    )
  ]),
  child: Center(child: Text(query == null ? "null" : '"$query"'))
)
""",
      child: SizedBox(
        height: 300,
        child: SearchExample(mode: SearchButtonMode.live),
      ),
    );

Widget get exampleSearchBox => ArcaneUsageExample(
      padding: 0,
      title: 'Search Box',
      code: r"""
FillScreen(
  header: Bar(titleText: "Header", trailing: [
    SearchBox(
      onEditingComplete: () => print("Editing Complete"),
      onSubmitted: (v) => setState(() => query = v),
      onChanged: (v) => setState(() => query = v),
      leading: Icon(Icons.search_outline_ionic),
      autofocus: false,
      placeholder: "Search!",
      minWidth: 0,
    )
  ]),
  child: Center(child: Text(query == null ? "null" : '"$query"'))
)
""",
      child: SizedBox(
        height: 300,
        child: SearchBoxExample(),
      ),
    );

Widget get exampleTableColumnSizes => ArcaneUsageExample(
    title: "Column Sizing",
    code: r"""
StaticTable(
  defaultColumnWidth: const ComfyColumnWidth(),
  columnWidths: const {
    // You can use 
    // ComfyColumnWidth - Combines Intrinsic & Flex Column Widths,
    // FixedColumnWidth - Fixed width for the column,
    // FractionColumnWidth - Fraction of the available space,
    // IntrinsicColumnWidth - Intrinsic width of the column,
    // MaxColumnWidth - Max width for the column,
    // MinColumnWidth - Min width for the column,
    // FlexColumnWidth - Flex width for the column like a row flex,
    
    0: ComfyColumnWidth(flex: 1),
    1: ComfyColumnWidth(flex: 4),
  },
  rows: [
    TR.header(
      column: [
        TD(Text("Cell 1")),
        TD(Text("Cell A")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 1")),
        TD(Text("Cell A")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR.footer(
      column: [
        TD(Text("Cell 1")),
        TD(Text("Cell A")),
      ],
    ),
  ],
)
    """,
    child: StaticTable(
      defaultColumnWidth: const ComfyColumnWidth(),
      columnWidths: const {
        0: ComfyColumnWidth(flex: 1),
        1: ComfyColumnWidth(flex: 4),
      },
      rows: [
        TR.header(
          column: [
            TD(Text("Cell 1")),
            TD(Text("Cell A")),
          ],
        ),
        TR(
          column: [
            TD(Text("Cell 1")),
            TD(Text("Cell A")),
          ],
        ),
        TR(
          column: [
            TD(Text("Cell 2")),
            TD(Text("Cell B")),
          ],
        ),
        TR(
          column: [
            TD(Text("Cell 2")),
            TD(Text("Cell B")),
          ],
        ),
        TR(
          column: [
            TD(Text("Cell 2")),
            TD(Text("Cell B")),
          ],
        ),
        TR(
          column: [
            TD(Text("Cell 2")),
            TD(Text("Cell B")),
          ],
        ),
        TR.footer(
          column: [
            TD(Text("Cell 1")),
            TD(Text("Cell A")),
          ],
        ),
      ],
    ));

Widget get exampleTables => ArcaneUsageExample(
    title: "Basic Tables",
    code: r"""
StaticTable(
  rows: [
    TR.header(
      column: [
        TD(Text("Cell 1")),
        TD(Text("Cell A")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 1")),
        TD(Text("Cell A")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR.footer(
      column: [
        TD(Text("Cell 1")),
        TD(Text("Cell A")),
      ],
    ),
  ],
)
    """,
    child: Row(
      children: [
        Expanded(
            child: StaticTable(
          rows: [
            TR.header(
              column: [
                TD(Text("Cell 1")),
                TD(Text("Cell A")),
              ],
            ),
            TR(
              column: [
                TD(Text("Cell 1")),
                TD(Text("Cell A")),
              ],
            ),
            TR(
              column: [
                TD(Text("Cell 2")),
                TD(Text("Cell B")),
              ],
            ),
            TR(
              column: [
                TD(Text("Cell 2")),
                TD(Text("Cell B")),
              ],
            ),
            TR(
              column: [
                TD(Text("Cell 2")),
                TD(Text("Cell B")),
              ],
            ),
            TR(
              column: [
                TD(Text("Cell 2")),
                TD(Text("Cell B")),
              ],
            ),
            TR.footer(
              column: [
                TD(Text("Cell 1")),
                TD(Text("Cell A")),
              ],
            ),
          ],
        ))
      ],
    ));

Widget get exampleTableAltColors => ArcaneUsageExample(
    title: "Alternating Row Color",
    code: r"""
StaticTable(
  alternatingRowColor: true,
  rows: [
    TR.header(
      column: [
        TD(Text("Cell 1")),
        TD(Text("Cell A")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 1")),
        TD(Text("Cell A")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR.footer(
      column: [
        TD(Text("Cell 1")),
        TD(Text("Cell A")),
      ],
    ),
  ],
)
    """,
    child: Row(
      children: [
        Expanded(
          child: StaticTable(
            alternatingRowColor: true,
            rows: [
              TR.header(
                column: [
                  TD(Text("Cell 1")),
                  TD(Text("Cell A")),
                ],
              ),
              TR(
                column: [
                  TD(Text("Cell 1")),
                  TD(Text("Cell A")),
                ],
              ),
              TR(
                column: [
                  TD(Text("Cell 2")),
                  TD(Text("Cell B")),
                ],
              ),
              TR(
                column: [
                  TD(Text("Cell 2")),
                  TD(Text("Cell B")),
                ],
              ),
              TR(
                column: [
                  TD(Text("Cell 2")),
                  TD(Text("Cell B")),
                ],
              ),
              TR(
                column: [
                  TD(Text("Cell 2")),
                  TD(Text("Cell B")),
                ],
              ),
              TR.footer(
                column: [
                  TD(Text("Cell 1")),
                  TD(Text("Cell A")),
                ],
              ),
            ],
          ),
        )
      ],
    ));

Widget get exampleTableWithColors => ArcaneUsageExample(
    title: "Colored Cells & Rows",
    code: r"""
StaticTable(
  rows: [
    TR.header(
      column: [
        TD(Text("Cell 1")),
        TD(Text("Cell A")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 1"), color: Colors.red.withOpacity(0.1)),
        TD(Text("Cell A")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2"), color: Colors.red.withOpacity(0.1)),
        TD(Text("Cell B"), color: Colors.blue.withOpacity(0.1)),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B"), color: Colors.blue.withOpacity(0.1)),
      ],
    ),
    TR(
      color: Colors.green.withOpacity(0.1),
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR(
      column: [
        TD(Text("Cell 2")),
        TD(Text("Cell B")),
      ],
    ),
    TR.footer(
      column: [
        TD(Text("Cell 1")),
        TD(Text("Cell A")),
      ],
    ),
  ],
)
    """,
    child: Row(
      children: [
        Expanded(
          child: StaticTable(
            rows: [
              TR.header(
                column: [
                  TD(Text("Cell 1")),
                  TD(Text("Cell A")),
                ],
              ),
              TR(
                column: [
                  TD(Text("Cell 1"), color: Colors.red.withOpacity(0.1)),
                  TD(Text("Cell A")),
                ],
              ),
              TR(
                column: [
                  TD(Text("Cell 2"), color: Colors.red.withOpacity(0.1)),
                  TD(Text("Cell B"), color: Colors.blue.withOpacity(0.1)),
                ],
              ),
              TR(
                column: [
                  TD(Text("Cell 2")),
                  TD(Text("Cell B"), color: Colors.blue.withOpacity(0.1)),
                ],
              ),
              TR(
                color: Colors.green.withOpacity(0.1),
                column: [
                  TD(Text("Cell 2")),
                  TD(Text("Cell B")),
                ],
              ),
              TR(
                column: [
                  TD(Text("Cell 2")),
                  TD(Text("Cell B")),
                ],
              ),
              TR.footer(
                column: [
                  TD(Text("Cell 1")),
                  TD(Text("Cell A")),
                ],
              ),
            ],
          ),
        )
      ],
    ));

Widget get exampleChatBubblesScreen => ArcaneUsageExample(
    title: "Chat Bubbles",
    code: r"""
ChatScreen(
  gutter: false,
  header: Bar(titleText: "Chat Bubbles"),
  style: ChatStyle.bubbles,
  provider: MyChatProvider(
    users: [
      MyUser(id: "0", name: "Dan"),
      MyUser(id: "1", name: "Alice"),
      MyUser(id: "2", name: "Bob"),
      MyUser(id: "3", name: "Charlie"),
    ], 
    messages: BehaviorSubject.seeded([])),
  sender: "0")

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
    ]);
  }
}
    """,
    child: SizedBox(
        height: 500,
        child: ChatScreen(
            gutter: false,
            header: Bar(titleText: "Chat Bubbles"),
            style: ChatStyle.bubbles,
            provider: MyChatProvider(users: [
              MyUser(id: "0", name: "Dan"),
              MyUser(id: "1", name: "Alice"),
              MyUser(id: "2", name: "Bob"),
              MyUser(id: "3", name: "Charlie"),
            ], messages: BehaviorSubject.seeded([])),
            sender: "0")));

Widget get exampleChatTilesScreen => ArcaneUsageExample(
    title: "Chat Tiles",
    code: r"""
ChatScreen(
  gutter: false,
  header: Bar(titleText: "Chat Bubbles"),
  style: ChatStyle.tiles,
  provider: MyChatProvider(
    users: [
      MyUser(id: "0", name: "Dan"),
      MyUser(id: "1", name: "Alice"),
      MyUser(id: "2", name: "Bob"),
      MyUser(id: "3", name: "Charlie"),
    ], 
    messages: BehaviorSubject.seeded([])),
  sender: "0")

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
    ]);
  }
}
    """,
    child: SizedBox(
        height: 500,
        child: ChatScreen(
            gutter: false,
            header: Bar(titleText: "Chat Tiles"),
            style: ChatStyle.tiles,
            provider: MyChatProvider(users: [
              MyUser(id: "0", name: "Dan"),
              MyUser(id: "1", name: "Alice"),
              MyUser(id: "2", name: "Bob"),
              MyUser(id: "3", name: "Charlie"),
            ], messages: BehaviorSubject.seeded([])),
            sender: "0")));

Widget get exampleImage => ArcaneUsageExample(
    title: "Image with Thumbhash",
    code: r"""
ImageView(
  // Thumbhashes are prioritized over blurhashes
  thumbHash: "XyMGHwD5d1hpp2d9dHaKdHd4mYAp9mcN",
  blurHash: r"URASz$ofs^j]ogfffPoPs]fRWQfPj]oPfRW7",
  style: ImageStyle(fit: BoxFit.contain, width: 200, height: 200),
  url: Future.delayed(
      Duration(seconds: 1),
      () =>
          "https://github.com/ArcaneArts/ArcaneArts/blob/main/icon/bg_512.png?raw=true")
)
    """,
    child: ImageView(
        // Thumbhashes are prioritized over blurhashes
        thumbHash: "XyMGHwD5d1hpp2d9dHaKdHd4mYAp9mcN",
        blurHash: r"URASz$ofs^j]ogfffPoPs]fRWQfPj]oPfRW7",
        style: ImageStyle(fit: BoxFit.contain, width: 200, height: 200),
        url: Future.delayed(
            Duration(seconds: 1),
            () =>
                "https://github.com/ArcaneArts/ArcaneArts/blob/main/icon/bg_512.png?raw=true")));

Widget get exampleCenterBodySimple => ArcaneUsageExample(
    title: "Simple Center Body",
    code: """
CenterBody(icon: Icons.warning_fill, message: "Not Found")
    """,
    child: CenterBody(icon: Icons.warning_fill, message: "Not Found"));

Widget get exampleCenterBodyAction => ArcaneUsageExample(
    title: "Center Body with Action",
    code: """
CenterBody(icon: Icons.warning_fill, message: "Not Found", 
  actionText: "Refresh", 
  onActionPressed: () => print("Refreshing...")
)
    """,
    child: CenterBody(
        icon: Icons.warning_fill,
        message: "Not Found",
        actionText: "Refresh",
        onActionPressed: () {
          print("Refreshing...");
        }));

Widget get exampleDialogConfirm => ArcaneUsageExample(
    title: "Confirm Dialog",
    code: """
PrimaryButton(
  leading: Icon(Icons.open_outline_ionic),onPressed: () => DialogConfirm(
    title: "Title Text",
    confirmText: "Confirm Text",
    cancelText: "Cancel Text",  onConfirm: () => print("Confirmed"),
    description: "Description Text goes here",
  ).open(_context),
  child: Text("Confirm Dialog"),
)
    """,
    child: PrimaryButton(
      leading: Icon(Icons.open_outline_ionic),
      onPressed: () => DialogConfirm(
        title: "Title Text",
        confirmText: "Confirm Text",
        cancelText: "Cancel Text",
        onConfirm: () => print("Confirmed"),
        description: "Description Text goes here",
      ).open(_context),
      child: Text("Confirm Dialog"),
    ));

Widget get exampleDialogDate => ArcaneUsageExample(
    title: "Date Dialog",
    code: """
PrimaryButton(
  leading: Icon(Icons.open_outline_ionic),
  onPressed: () => DialogDate(
    title: "Title Text",
    confirmText: "Confirm Text",
    cancelText: "Cancel Text",
    onConfirm: (t) => print(t),
    // Block out ALL fridays from being selected
    stateBuilder: (date) => date.weekday == DateTime.friday ? DateState.disabled : DateState.enabled,
  ).open(_context),
  child: Text("Date Dialog"),
)
    """,
    child: PrimaryButton(
      leading: Icon(Icons.open_outline_ionic),
      onPressed: () => DialogDate(
        title: "Title Text",
        confirmText: "Confirm Text",
        cancelText: "Cancel Text",
        onConfirm: (t) => print(t),
        // Block out ALL fridays from being selected
        stateBuilder: (date) => date.weekday == DateTime.friday
            ? DateState.disabled
            : DateState.enabled,
      ).open(_context),
      child: Text("Date Dialog"),
    ));

Widget get exampleDialogDateRange => ArcaneUsageExample(
    title: "Date Range Dialog",
    code: """
PrimaryButton(
  leading: Icon(Icons.open_outline_ionic),
  onPressed: () => DialogDateRange(
    title: "Title Text",
    confirmText: "Confirm Text",
    cancelText: "Cancel Text",
    onConfirm: (t) => print(t),
    // Block every other day from being selected as the start or stop
    // This will allow you to select through blocked days though
    stateBuilder: (date) => date.day % 2 == 0 ? DateState.disabled : DateState.enabled,
  ).open(_context),
  child: Text("Date Range Dialog"),
)
    """,
    child: PrimaryButton(
      leading: Icon(Icons.open_outline_ionic),
      onPressed: () => DialogDateRange(
        title: "Title Text",
        confirmText: "Confirm Text",
        cancelText: "Cancel Text",
        onConfirm: (t) => print(t),
        // Block every other day from being selected as the start or stop
        // This will allow you to select through blocked days though
        stateBuilder: (date) =>
            date.day % 2 == 0 ? DateState.disabled : DateState.enabled,
      ).open(_context),
      child: Text("Date Range Dialog"),
    ));

Widget get exampleDialogDateMulti => ArcaneUsageExample(
    title: "Multi Date Dialog",
    code: """
PrimaryButton(
  leading: Icon(Icons.open_outline_ionic),
  onPressed: () => DialogDateMulti(
    title: "Title Text",
    confirmText: "Confirm Text",
    cancelText: "Cancel Text",
    onConfirm: (t) => print(t),
    // Block every 7 days from being selected as the start or stop
    // This will allow you to select through blocked days though
    stateBuilder: (date) =>
        date.day % 7 == 0 ? DateState.disabled : DateState.enabled,
  ).open(_context),
  child: Text("Multi Date Dialog"),
)
    """,
    child: PrimaryButton(
      leading: Icon(Icons.open_outline_ionic),
      onPressed: () => DialogDateMulti(
        title: "Title Text",
        confirmText: "Confirm Text",
        cancelText: "Cancel Text",
        onConfirm: (t) => print(t),
        // Block every 7 days from being selected as the start or stop
        // This will allow you to select through blocked days though
        stateBuilder: (date) =>
            date.day % 7 == 0 ? DateState.disabled : DateState.enabled,
      ).open(_context),
      child: Text("Multi Date Dialog"),
    ));

Widget get exampleDialogTime => ArcaneUsageExample(
    title: "Time Dialog",
    code: """
PrimaryButton(
  leading: Icon(Icons.open_outline_ionic),
  onPressed: () => DialogDateMulti(
    showSeconds: false,
    use24HourFormat: false,
    title: "Title Text",
    confirmText: "Confirm Text",
    cancelText: "Cancel Text",
    onConfirm: (t) => print(t),
  ).open(_context),
  child: Text("Time Dialog"),
)
    """,
    child: PrimaryButton(
      leading: Icon(Icons.open_outline_ionic),
      onPressed: () => DialogTime(
        showSeconds: false,
        use24HourFormat: false,
        title: "Title Text",
        confirmText: "Confirm Text",
        cancelText: "Cancel Text",
        onConfirm: (t) => print(t),
      ).open(_context),
      child: Text("Time Dialog"),
    ));

Widget get exampleDialogText => ArcaneUsageExample(
    title: "Text Dialog",
    code: """
PrimaryButton(
  leading: Icon(Icons.open_outline_ionic),
  onPressed: () => DialogText(
    title: "Title Text",
    confirmText: "Confirm Text",
    cancelText: "Cancel Text",
    onConfirm: (t) => print(t),
    description: "Description Text goes here",
    hint: "Hint Text",
  ).open(_context),
  child: Text("Text Dialog"),
)
    """,
    child: PrimaryButton(
      leading: Icon(Icons.open_outline_ionic),
      onPressed: () => DialogText(
        title: "Title Text",
        confirmText: "Confirm Text",
        cancelText: "Cancel Text",
        onConfirm: (t) => print(t),
        description: "Description Text goes here",
        hint: "Hint Text",
      ).open(_context),
      child: Text("Text Dialog"),
    ));

Widget get exampleDialogConfirmText => ArcaneUsageExample(
    title: "Confirm Text Dialog",
    code: """
PrimaryButton(
  leading: Icon(Icons.open_outline_ionic),
  onPressed: () => DialogConfirmText(
    title: "Title Text",
    confirmText: "Confirm Text",
    ignoreCase: true,
    cancelText: "Cancel Text",
    onConfirm: () => print("Confirmed"),
    description: "Please type 'derp' to continue.",
    verificationText: "derp",
  ).open(_context),
  child: Text("Confirm Text Dialog"),
)
    """,
    child: PrimaryButton(
      leading: Icon(Icons.open_outline_ionic),
      onPressed: () => DialogConfirmText(
        title: "Title Text",
        confirmText: "Confirm Text",
        ignoreCase: true,
        cancelText: "Cancel Text",
        onConfirm: () => print("Confirmed"),
        description: "Please type 'derp' to continue.",
        verificationText: "derp",
      ).open(_context),
      child: Text("Confirm Text Dialog"),
    ));

Widget get exampleDialogEmail => ArcaneUsageExample(
    title: "Email Dialog",
    code: """
PrimaryButton(
  leading: Icon(Icons.open_outline_ionic),
  onPressed: () => DialogEmail(
    title: "Title Text",
    confirmText: "Confirm Text",
    cancelText: "Cancel Text",
    onConfirm: (e) => print(e),
    description: "Please enter an email address.",
  ).open(_context),
  child: Text("Email Dialog"),
)
    """,
    child: PrimaryButton(
      leading: Icon(Icons.open_outline_ionic),
      onPressed: () => DialogEmail(
        title: "Title Text",
        confirmText: "Confirm Text",
        cancelText: "Cancel Text",
        onConfirm: (e) => print(e),
        description: "Please enter an email address.",
      ).open(_context),
      child: Text("Email Dialog"),
    ));

Widget get exampleDialogCommand => ArcaneUsageExample(
    title: "Command Dialog",
    code: """
PrimaryButton(
  leading: Icon(Icons.open_outline_ionic),
  onPressed: () => DialogCommand(
    leading: Icon(Icons.airplane),
    onConfirm: (e) => print(e),
    options: {
      "Alpha",
      "Beta",
      "Gamma",
      "Delta",
      "Epsilon",
      "Zeta",
      "Eta",
      "Theta",
      "Iota",
      "Kappa",
      "Lambda",
      "Mu",
      "Nu",
      "Xi",
      "Omicron",
      "Pi",
      "Rho",
      "Sigma",
      "Tau",
      "Upsilon",
      "Phi",
      "Chi",
      "Psi",
      "Omega"
    },
  ).open(_context),
  child: Text("Command Dialog"),
)
    """,
    child: PrimaryButton(
      leading: Icon(Icons.open_outline_ionic),
      onPressed: () => DialogCommand(
        leading: Icon(Icons.airplane),
        onConfirm: (e) => print(e),
        options: {
          "Alpha",
          "Beta",
          "Gamma",
          "Delta",
          "Epsilon",
          "Zeta",
          "Eta",
          "Theta",
          "Iota",
          "Kappa",
          "Lambda",
          "Mu",
          "Nu",
          "Xi",
          "Omicron",
          "Pi",
          "Rho",
          "Sigma",
          "Tau",
          "Upsilon",
          "Phi",
          "Chi",
          "Psi",
          "Omega"
        },
      ).open(_context),
      child: Text("Command Dialog"),
    ));

Widget get exampleScreenNavigation => ArcaneUsageExample(
      padding: 0,
      title: 'Navigation Screens',
      code: r"""
NavigationScreen(
  type: type,
  index: index,
  onIndexChanged: (index) => setState(() => this.index = index),
  tabs: [
    NavTab(
        label: "Tab 1",
        icon: Icons.activity,
        selectedIcon: Icons.activity_fill,
        builder: (context) => SliverScreen(
            gutter: false,
            header: Bar(titleText: "Tab 1"),
            sliver: SListView.builder(
                childCount: 10,
                builder: (context, i) => ListTile(
                      title: Text("Item $i"),
                      subtitle: Text("Subtitle or something"),
                      leading: Icon(Icons.activity),
                    )))),
    NavTab(
        label: "Tab 2",
        icon: Icons.address_book,
        selectedIcon: Icons.address_book_fill,
        builder: (context) => SliverScreen(
            gutter: false,
            header: Bar(titleText: "Tab 2"),
            sliver: SGridView.builder(
                crossAxisCount: 3,
                childCount: 10,
                builder: (context, i) => Card(
                      child: Basic(
                        title: Text("Item $i"),
                        subtitle: Text("Subtitle or something"),
                        leading: Icon(Icons.activity),
                      ),
                    )))),
    NavTab(
        label: "Tab 3",
        icon: Icons.gear_six,
        selectedIcon: Icons.gear_six_fill,
        builder: (context) => FillScreen(
            gutter: false,
            header: Bar(titleText: "Tab 3"),
            child: Center(
              child: CardCarousel(
                children: [
                  RadioCards<NavigationType>(
                      builder: (nt) => Basic(title: Text(nt.name)),
                      onChanged: (nt) => setState(() => type = nt),
                      items: NavigationType.values,
                      value: type)
                ],
              ),
            )))
  ]
)
""",
      child: SizedBox(
        height: 500,
        child: ExampleNavigationScreen(),
      ),
    );

Widget get exampleScreenSliverSections => ArcaneUsageExample(
      padding: 0,
      title: 'Sliver Sections',
      code: r"""
SliverScreen(
  gutter: false,
  header: Bar(titleText: "Header", trailing: [
    IconButton(
      icon: Icon(Icons.activity),
      onPressed: () {},
    )
  ]),
  sliver: MultiSliver(
    children: [
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        sliver: SGridView.builder(
          childCount: 16,
          crossAxisSpacing: 8,
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 8,
          builder: (context, index) => Card(
            child: Center(
              child: Basic(
                title: Text("Item s1 $index"),
                subtitle: Text("Subtitle or something"),
              ),
            ),
          ),
        ),
      ),
      BarSection(
          titleText: "Grid Section",
          subtitleText: "Subtitle or something",
          trailing: [
            IconButton(
              icon: Icon(Icons.add_circle_ionic),
              onPressed: () {},
            )
          ],
          sliver: SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            sliver: SGridView.builder(
              childCount: 24,
              crossAxisSpacing: 8,
              childAspectRatio: 2,
              mainAxisSpacing: 8,
              builder: (context, index) => Card(
                child: Center(
                  child: Basic(
                    title: Text("Item $index"),
                    subtitle: Text("Subtitle or something"),
                  ),
                ),
              ),
            ),
          ))
    ],
  )
)
""",
      child: SizedBox(
        height: 500,
        child: SliverScreen(
            gutter: false,
            header: Bar(titleText: "Header", trailing: [
              IconButton(
                icon: Icon(Icons.activity),
                onPressed: () {},
              )
            ]),
            sliver: MultiSliver(
              children: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  sliver: SGridView.builder(
                    childCount: 4,
                    crossAxisSpacing: 8,
                    maxCrossAxisExtent: 400,
                    childAspectRatio: 1,
                    mainAxisSpacing: 8,
                    builder: (context, index) => Card(
                      child: Center(
                        child: Basic(
                          title: Text("Item s1 $index"),
                          subtitle: Text("Subtitle or something"),
                        ),
                      ),
                    ),
                  ),
                ),
                BarSection(
                    titleText: "Grid Section",
                    subtitleText: "Subtitle or something",
                    trailing: [
                      IconButton(
                        icon: Icon(Icons.add_circle_ionic),
                        onPressed: () {},
                      )
                    ],
                    sliver: SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      sliver: SGridView.builder(
                        childCount: 24,
                        crossAxisSpacing: 8,
                        childAspectRatio: 2,
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 8,
                        builder: (context, index) => Card(
                          child: Center(
                            child: Basic(
                              title: Text("Item $index"),
                              subtitle: Text("Subtitle or something"),
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            )),
      ),
    );

Widget get exampleScreenSliver => ArcaneUsageExample(
      padding: 0,
      title: 'Sliver Screens',
      code: r"""
SliverScreen(
  gutter: false,
  header: Bar(titleText: "Header", trailing: [
    IconButton(
      icon: Icon(Icons.activity),
      onPressed: () {},
    )
  ]),
  sliver: SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 8),
    sliver: SGridView.builder(
      childCount: 24,
      crossAxisSpacing: 8,
      childAspectRatio: 2,
      mainAxisSpacing: 8,
      builder: (context, index) => Card(
        child: Center(
          child: Basic(
            title: Text("Item $index"),
            subtitle: Text("Subtitle or something"),
          ),
        ),
      ),
    ),
  )
)
""",
      child: SizedBox(
        height: 500,
        child: SliverScreen(
            gutter: false,
            header: Bar(titleText: "Header", trailing: [
              IconButton(
                icon: Icon(Icons.activity),
                onPressed: () {},
              )
            ]),
            sliver: SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              sliver: SGridView.builder(
                childCount: 24,
                crossAxisSpacing: 8,
                childAspectRatio: 2,
                mainAxisSpacing: 8,
                maxCrossAxisExtent: 200,
                builder: (context, index) => Card(
                  child: Center(
                    child: Basic(
                      title: Text("Item $index"),
                      subtitle: Text("Subtitle or something"),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );

Widget get exampleScreenFill => ArcaneUsageExample(
      padding: 0,
      title: 'Fill Screens',
      code: """
FillScreen(
  header: Bar(
    titleText: "Header",
    trailing: [
      IconButton(
        icon: Icon(Icons.activity),
        onPressed: () {},
      )]),
  child: Center(
    child: Text("Fill Screen")
  )
)
""",
      child: SizedBox(
        height: 500,
        child: FillScreen(
            header: Bar(titleText: "Header", trailing: [
              IconButton(
                icon: Icon(Icons.activity),
                onPressed: () {},
              )
            ]),
            child: Center(child: Text("Fill Screen"))),
      ),
    );

class ExampleNavigationScreen extends StatefulWidget {
  const ExampleNavigationScreen({super.key});

  @override
  State<ExampleNavigationScreen> createState() =>
      _ExampleNavigationScreenState();
}

class _ExampleNavigationScreenState extends State<ExampleNavigationScreen> {
  NavigationType type = NavigationType.bottomNavigationBar;
  int index = 0;

  @override
  Widget build(BuildContext context) => NavigationScreen(
          type: type,
          index: index,
          onIndexChanged: (index) => setState(() => this.index = index),
          tabs: [
            NavTab(
                label: "Tab 1",
                icon: Icons.activity,
                selectedIcon: Icons.activity_fill,
                builder: (context) => SliverScreen(
                    gutter: false,
                    header: Bar(titleText: "Tab 1"),
                    sliver: SListView.builder(
                        childCount: 10,
                        builder: (context, i) => ListTile(
                              title: Text("Item $i"),
                              subtitle: Text("Subtitle or something"),
                              leading: Icon(Icons.activity),
                            )))),
            NavTab(
                label: "Tab 2",
                icon: Icons.address_book,
                selectedIcon: Icons.address_book_fill,
                builder: (context) => SliverScreen(
                    gutter: false,
                    header: Bar(titleText: "Tab 2"),
                    sliver: SGridView.builder(
                        crossAxisCount: 3,
                        childCount: 10,
                        builder: (context, i) => Card(
                              child: Basic(
                                title: Text("Item $i"),
                                subtitle: Text("Subtitle or something"),
                                leading: Icon(Icons.activity),
                              ),
                            )))),
            NavTab(
                label: "Tab 3",
                icon: Icons.gear_six,
                selectedIcon: Icons.gear_six_fill,
                builder: (context) => FillScreen(
                    gutter: false,
                    header: Bar(titleText: "Tab 3"),
                    child: Center(
                      child: CardCarousel(
                        children: [
                          RadioCards<NavigationType>(
                              builder: (nt) => Basic(title: Text(nt.name)),
                              onChanged: (nt) => setState(() => type = nt),
                              items: NavigationType.values,
                              value: type)
                        ],
                      ),
                    )))
          ]);
}

/////////////////////////////////////////////////////////////////////////////////////////////

class ShadcnWrapper extends StatelessWidget {
  final Widget child;

  const ShadcnWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    sh.ThemeData t = sh.Theme.of(context);
    return Theme(
      data: ThemeData(
          radius: t.radius,
          surfaceBlur: t.surfaceBlur,
          surfaceOpacity: t.surfaceOpacity,
          iconTheme: IconThemeProperties(
            large: t.iconTheme.large,
            medium: t.iconTheme.medium,
            small: t.iconTheme.small,
            x2Large: t.iconTheme.x2Large,
            x2Small: t.iconTheme.x2Small,
            x3Large: t.iconTheme.x3Large,
            x3Small: t.iconTheme.x3Small,
            x4Large: t.iconTheme.x4Large,
            x4Small: t.iconTheme.x4Small,
            xLarge: t.iconTheme.xLarge,
            xSmall: t.iconTheme.xSmall,
          ),
          platform: t.platform,
          scaling: t.scaling,
          typography: Typography(
              sans: t.typography.sans,
              mono: t.typography.mono,
              xSmall: t.typography.xSmall,
              small: t.typography.small,
              base: t.typography.base,
              large: t.typography.large,
              xLarge: t.typography.xLarge,
              x2Large: t.typography.x2Large,
              x3Large: t.typography.x3Large,
              x4Large: t.typography.x4Large,
              x5Large: t.typography.x5Large,
              x6Large: t.typography.x6Large,
              x7Large: t.typography.x7Large,
              x8Large: t.typography.x8Large,
              x9Large: t.typography.x9Large,
              thin: t.typography.thin,
              light: t.typography.light,
              extraLight: t.typography.extraLight,
              normal: t.typography.normal,
              medium: t.typography.medium,
              semiBold: t.typography.semiBold,
              bold: t.typography.bold,
              extraBold: t.typography.extraBold,
              black: t.typography.black,
              italic: t.typography.italic,
              h1: t.typography.h1,
              h2: t.typography.h2,
              h3: t.typography.h3,
              h4: t.typography.h4,
              p: t.typography.p,
              blockQuote: t.typography.blockQuote,
              inlineCode: t.typography.inlineCode,
              lead: t.typography.lead,
              textLarge: t.typography.textLarge,
              textSmall: t.typography.textSmall,
              textMuted: t.typography.textMuted),
          colorScheme: ColorScheme.fromMap(t.colorScheme.toMap())),
      child: Builder(builder: (context) => child),
    );
  }
}

class ArcaneUsageExample extends StatefulWidget {
  final String? title;
  final Widget child;
  final String code;
  final bool summarize;
  final double padding;

  const ArcaneUsageExample({
    super.key,
    this.title,
    required this.child,
    required this.code,
    this.summarize = true,
    this.padding = 40,
  });

  @override
  State<ArcaneUsageExample> createState() => _ArcaneUsageExampleState();
}

class _ArcaneUsageExampleState extends State<ArcaneUsageExample> {
  int index = 0;
  final GlobalKey _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null) Text(widget.title!).h2(),
        if (widget.title != null) const Gap(12),
        TabList(
          index: index,
          children: [
            TabButton(
              onPressed: () {
                setState(() {
                  index = 0;
                });
              },
              child: const Text('Preview').semiBold().textSmall(),
            ),
            TabButton(
              onPressed: () {
                setState(() {
                  index = 1;
                });
              },
              child: const Text('Code').semiBold().textSmall(),
            ),
          ],
        ),
        const Gap(12),
        RepaintBoundary(
          child: Offstage(
            offstage: index != 0,
            child: OutlinedContainer(
              key: _key,
              child: ClipRect(
                child: Container(
                  padding: EdgeInsets.all(widget.padding),
                  constraints: const BoxConstraints(minHeight: 350),
                  child: Center(
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
        RepaintBoundary(
          child: Offstage(
            offstage: index != 1,
            child: ArcaneCodeSnippetBuilder(
              code: widget.code,
              mode: 'dart',
              summarize: widget.summarize,
            ),
          ),
        )
      ],
    );
  }
}

class ArcaneCodeSnippetBuilder extends StatefulWidget {
  final String code;
  final String mode;
  final bool summarize;

  const ArcaneCodeSnippetBuilder({
    super.key,
    required this.code,
    this.mode = 'dart',
    this.summarize = true,
  });

  @override
  State<ArcaneCodeSnippetBuilder> createState() =>
      _ArcaneCodeSnippetBuilderState();
}

class _ArcaneCodeSnippetBuilderState extends State<ArcaneCodeSnippetBuilder> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CodeSnippet(
      code: widget.code,
      mode: widget.mode,
    );
  }
}

class ArcaneComponentPage extends StatefulWidget {
  final String name;
  final String displayName;
  final String description;
  final List<Widget> children;
  final bool component;
  const ArcaneComponentPage({
    super.key,
    required this.name,
    required this.description,
    required this.displayName,
    required this.children,
    this.component = true,
  });

  @override
  State<ArcaneComponentPage> createState() => _ArcaneComponentPageState();
}

class _ArcaneComponentPageState extends State<ArcaneComponentPage> {
  final List<GlobalKey> keys = [];
  final Map<String, OnThisPage> onThisPage = {};

  @override
  void initState() {
    super.initState();
    for (final child in widget.children) {
      if (child is! ArcaneUsageExample) {
        continue;
      }
      final title = child.title;
      if (title == null) {
        continue;
      }
      final key = GlobalKey();
      keys.add(key);
      onThisPage[title] = OnThisPage();
    }
  }

  @override
  void didUpdateWidget(covariant ArcaneComponentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.children, widget.children)) {
      keys.clear();
      onThisPage.clear();
      for (final child in widget.children) {
        if (child is! ArcaneUsageExample) {
          continue;
        }
        final title = child.title;
        if (title == null) {
          continue;
        }
        final key = GlobalKey();
        keys.add(key);
        onThisPage[title] = OnThisPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> remappedChildren = [];
    int i = 0;
    for (final child in widget.children) {
      if (child is! ArcaneUsageExample) {
        remappedChildren.add(child);
        continue;
      }
      final title = child.title;
      final key = keys[i];
      if (title == null) {
        continue;
      }
      remappedChildren.add(
        PageItemWidget(
          onThisPage: onThisPage[title]!,
          key: key,
          child: child,
        ),
      );
      i++;
    }
    return ShadcnWrapper(
        child: DocsPage(
      name: widget.name,
      onThisPage: onThisPage,
      navigationItems: [
        if (widget.component)
          TextButton(
            density: ButtonDensity.compact,
            onPressed: () {
              context.pushNamed('components');
            },
            child: const Text('Components'),
          ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText(widget.displayName).h1(),
          SelectableText(widget.description).lead(),
          ...remappedChildren,
        ],
      ),
    ));
  }
}

mixin ArcaneExample {}

typedef Logo = ArcaneArtsLogo;

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

class SearchExample extends StatefulWidget {
  final SearchButtonMode mode;

  const SearchExample({super.key, required this.mode});

  @override
  State<SearchExample> createState() => _SearchExampleState();
}

class _SearchExampleState extends State<SearchExample> {
  String? query;

  @override
  Widget build(BuildContext context) => FillScreen(
      header: Bar(titleText: "Header", trailing: [
        SearchButton(
          mode: widget.mode,
          onSearch: (v) => setState(() {
            query = v;
          }),
        )
      ]),
      child: Center(child: Text(query == null ? "null" : '"$query"')));
}

class SearchBoxExample extends StatefulWidget {
  const SearchBoxExample({super.key});

  @override
  State<SearchBoxExample> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBoxExample> {
  String? query;

  @override
  Widget build(BuildContext context) => FillScreen(
      header: Bar(titleText: "Header", trailing: [
        SearchBox(
          onEditingComplete: () => print("Editing Complete"),
          onSubmitted: (v) => setState(() => query = v),
          onChanged: (v) => setState(() => query = v),
          leading: Icon(Icons.search_outline_ionic),
          autofocus: false,
          placeholder: "Search!",
          minWidth: 0,
        )
      ]),
      child: Center(child: Text(query == null ? "null" : '"$query"')));
}
