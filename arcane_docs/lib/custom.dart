import 'package:arcane/arcane.dart';
import 'package:docs/pages/docs_page.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh hide TextExtension;

//////////////////////////////////////////////////////////////////////////////////////////
List<GoRoute> customRoutes = [
  GoRoute(
      path: "screens",
      name: "screens",
      builder: (_, __) => const ScreensExample())
];
//////////////////////////////////////////////////////////////////////////////////////////
List<ShadcnDocsSection> customSections = [
  ShadcnDocsSection("Arcane", [ShadcnDocsPage("Screens", "screens")])
];
//////////////////////////////////////////////////////////////////////////////////////////

////////////////// Screens //////////////////
class ScreensExample extends StatelessWidget {
  const ScreensExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ArcaneComponentPage(
      name: 'screen',
      description:
          'Arcane screens allow you to easily create scaffolds of various types & uses.',
      displayName: 'Screens',
      children: [
        ArcaneUsageExample(
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
        ),
        ArcaneUsageExample(
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
        ),
        ArcaneUsageExample(
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
        )
      ],
    );
  }
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
      child: child,
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

String _formatCode(String code) {
  // check if code uses stateful widget
  if (code.contains('StatefulWidget')) {
    RegExp exp = RegExp(r'extends[\s]*State<.+?>[\s]*{[\s]*\n(.*)[\s]*}',
        multiLine: true, dotAll: true);
    var firstMatch = exp.firstMatch(code);
    if (firstMatch == null) {
      return code;
    }
    code = firstMatch.group(1)!;
    List<String> lines = code.split('\n');
    String formatted = '';
    // count the number of spaces in the 2nd line
    int spaces = lines.first.length - lines.first.trimLeft().length;
    // spaces is now the standard indentation length
    // now replace the indentation with the standard indentation length
    for (int i = 0; i < lines.length; i++) {
      int sub = spaces.clamp(0, lines[i].length);
      formatted += lines[i].substring(sub);
      if (i < lines.length - 1) {
        formatted += '\n';
      }
    }
    return formatted;
  }
  RegExp exp = RegExp(
    r'return[\s]*(.+)?[\s]*;[\s]*}[\s]*}',
    multiLine: true,
    dotAll: true,
  );
  var firstMatch = exp.firstMatch(code);
  assert(firstMatch != null, 'Code snippet must have a return statement');
  code = firstMatch!.group(1)!;
  // remove the indentation by one level for each line except the first line
  List<String> lines = code.split('\n');
  String formatted = lines.first;
  if (lines.length < 2) {
    return code;
  }
  formatted += '\n';
  // count the number of spaces in the 2nd line
  int spaces = lines[1].length - lines[1].trimLeft().length;
  // divide floor by 2 because 2
  spaces = (spaces / 2).floor() + 1;
  // spaces is now the standard indentation length
  // now replace the indentation with the standard indentation length
  for (int i = 1; i < lines.length; i++) {
    int sub = spaces.clamp(0, lines[i].length);
    formatted += lines[i].substring(sub);
    if (i < lines.length - 1) {
      formatted += '\n';
    }
  }
  return formatted;
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
