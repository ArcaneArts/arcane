import 'package:arcane/arcane.dart';
import 'package:example/screen/license.dart';

// The settings screen is the same but this time we make a stateful screen
// its mostly the same really
class SettingsScreen extends ArcaneStatefulScreen {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

  // Just define the settings path as /settings
  @override
  String toPath() => "/settings";
}

// The state is the same as any other state
class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [
            ...licenseTexts.keys.map((license) => ListTile(
                  title: Text(license),
                  onTap: () => LicenseViewerScreen(license: license)
                      .open(context), // open arcane screen with params
                ))
          ],
        ),
      );
}
