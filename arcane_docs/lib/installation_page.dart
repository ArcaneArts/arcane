import 'package:docs/pages/docs_page.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InstallationPage extends StatefulWidget {
  const InstallationPage({super.key});

  @override
  _InstallationPageState createState() => _InstallationPageState();
}

class _InstallationPageState extends State<InstallationPage> {
  final OnThisPage _manualKey = OnThisPage();
  final OnThisPage _experimentalKey = OnThisPage();
  @override
  Widget build(BuildContext context) {
    return DocsPage(
      name: 'installation',
      onThisPage: {
        'Install Manually': _manualKey,
        'Experimental Version': _experimentalKey,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Installation').h1(),
          const Text('Install and configure arcane in your project.').lead(),
          const Text('Install Manually').h2().anchored(_manualKey),
          const Gap(32),
          Steps(
            children: [
              StepItem(
                title: const Text('Creating a new Flutter project'),
                content: [
                  const Text(
                          'Create a new Flutter project using the following command:')
                      .p(),
                  const CodeSnippet(
                    code: 'flutter create my_app\ncd my_app',
                    mode: 'shell',
                  ).p(),
                ],
              ),
              StepItem(
                title: const Text('Adding the dependency'),
                content: [
                  const Text('Next, add the arcane dependency to your project.')
                      .p(),
                  const CodeSnippet(
                    code: 'flutter pub add arcane',
                    mode: 'shell',
                  ).p(),
                ],
              ),
              StepItem(
                title: const Text('Importing the package'),
                content: [
                  const Text(
                          'Now, you can import the package in your Dart code.')
                      .p(),
                  const CodeSnippet(
                    code: 'import \'package:arcame/arcame.dart\';',
                    mode: 'dart',
                  ).p(),
                ],
              ),
              StepItem(
                title: const Text('Adding the ArcaneApp widget'),
                content: [
                  const Text('Add the ArcaneApp widget to your main function.')
                      .p(),
                  const CodeSnippet(
                    code: '''
void main() {
  runApp(
    ArcaneApp(
      title: 'My App',
      home: MyHomePage(),
      theme: ArcaneTheme(
        scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc),
        radius: 0.5,
        surfaceOpacity: 0.66,
        surfaceBlur: 18,
        themeMode: ThemeMode.system
      ),
    ),
  );
}
                    ''',
                    mode: 'dart',
                  ).p(),
                ],
              ),
              StepItem(
                title: const Text('Add the fonts'),
                content: [
                  const Text('Add the fonts to your pubspec.yaml file.').p(),
                  const CodeSnippet(
                    code: '''
  shaders:
    - packages/arcane/resources/shaders/frost.frag
    - packages/arcane/resources/shaders/pixelate.frag
    - packages/arcane/resources/shaders/pixelate_blur.frag
    - packages/arcane/resources/shaders/rgb.frag
    - packages/arcane/resources/shaders/loader.frag
    - packages/arcane/resources/shaders/glyph.frag
    - packages/arcane/resources/shaders/invert.frag
    - packages/arcane/resources/shaders/warp.frag
    - packages/arcane/resources/shaders/black_hole.frag
    - packages/arcane/resources/shaders/lux.frag
    - packages/arcane/resources/shaders/cascade.frag
    - packages/arcane/resources/shaders/edge.frag
    - packages/arcane/resources/shaders/arcane_blur.frag''',
                    mode: 'yaml',
                  ).sized(height: 300).p(),
                ],
              ),
              StepItem(
                title: const Text('Run the app'),
                content: [
                  const Text('Run the app using the following command:').p(),
                  const CodeSnippet(
                    code: 'flutter run',
                    mode: 'shell',
                  ).p(),
                ],
              ),
            ],
          ),
          const Text('Experimental Version').h2().anchored(_experimentalKey),
          const Text('Experimental versions are available on GitHub.').p(),
          const Text(
                  'To use an experimental version, use git instead of version number in your '
                  'pubspec.yaml file:')
              .p(),
          const CodeSnippet(
            // code: 'shadcn_flutter:\n'
            //     '  git:\n'
            //     '    url: "https://github.com/ArcaneArts/arcane.git"',
            code: 'dependencies:\n'
                '  shadcn_flutter:\n'
                '    git:\n'
                '      url: "https://github.com/ArcaneArts/arcane.git"',
            mode: 'yaml',
          ).p(),
          const Text('See ')
              .thenButton(
                  onPressed: () {
                    launchUrlString(
                        'https://dart.dev/tools/pub/dependencies#git-packages');
                  },
                  child: const Text('this page'))
              .thenText(' for more information.')
              .p(),
          const Gap(16),
          const Alert(
            destructive: true,
            leading: Icon(Icons.warning),
            title: Text('Warning'),
            content: Text(
              'Experimental versions may contain breaking changes and are not recommended for production use. '
              'This version is intended for testing and development purposes only.',
            ),
          ),
        ],
      ),
    );
  }
}
