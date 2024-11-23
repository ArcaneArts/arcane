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
    ShadcnDocsPage("Chat", "chat"),
    ShadcnDocsPage("Tables", "tables"),
    ShadcnDocsPage("Dialogs", "dialogs"),
    ShadcnDocsPage("Image", "image"),
    ShadcnDocsPage("Center Body", "center_body"),
  ])
];

//////////////////////////////////////////////////////////////////////////////////////////
List<GoRoute> customRoutes = [
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
              exampleDialogRange,
              exampleDialogMulti,
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
      path: "tables",
      name: "tables",
      builder: (_, __) => ArcaneComponentPage(
            name: 'tables',
            description:
                'Tables for Arcane are designed to be simple to use and easy to extend.',
            displayName: 'Tables',
            children: [
              exampleTables,
              exampleTableAltColors,
              exampleTableWithColors,
              exampleTableColumnSizes
            ],
          )),
];

//////////////////////////////////////////////////////////////////////////////////////////

Widget get exampleTableColumnSizes => ArcaneUsageExample(
    title: "Column Sizing",
    code: r"""
Table(
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
    child: Table(
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
Table(
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
            child: Table(
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
Table(
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
          child: Table(
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
Table(
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
          child: Table(
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

Widget get exampleDialogRange => ArcaneUsageExample(
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

Widget get exampleDialogMulti => ArcaneUsageExample(
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
        builder: (context, footer) => SliverScreen(
            gutter: false,
            footer: footer,
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
        builder: (context, footer) => SliverScreen(
            gutter: false,
            footer: footer,
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
        builder: (context, footer) => FillScreen(
            footer: footer,
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
                builder: (context, footer) => SliverScreen(
                    gutter: false,
                    footer: footer,
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
                builder: (context, footer) => SliverScreen(
                    gutter: false,
                    footer: footer,
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
                builder: (context, footer) => FillScreen(
                    footer: footer,
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
