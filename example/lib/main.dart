import 'package:arcane/arcane.dart';
import 'package:common_svgs/common_svgs.dart';
import 'package:example/firebase_options.dart';
import 'package:window_manager/window_manager.dart';

// Start the app by just calling Arcane with the required parameters.
void main() => Arcane(
      // Define app routes for navigation, uses goRouter but easier
      router: ArcaneRouter(routes: [
        // Define our home screen subrouted with settings
        const HomeScreen().subRoute([
          // Define our settings subroute as /settings
          const SettingsScreen().subRoute(
            [
              // Define our license viewer subroute as /settings/license
              // Since LicenseViewerScreen overrides buildRoute this will handle ?license url stuff
              const LicenseViewerScreen(
                license: "unspecified",
              ),
            ],
          ),
        ])
      ]),

      // Firebase options are required to initialize the app.
      // This is needed for the Firebase services to work.
      firebase: DefaultFirebaseOptions.currentPlatform,

      // Optionally provide a string representing an svg logo for your login
      // and other places. The [arcaneArtsLogo] is the default
      svgLogo: svgArcaneArts,

      // Events are optional and can be used to run code before and after
      // Initialization phases
      events: ArcaneEvents(
          // This is called before the app is initialized
          // Here is where you register services
          // If you return a future, the app will wait for it to complete
          onPreInit: () {
            services().register<MyAppService>(() => MyAppService());
          },
          onWindowManagerShown: () {
            // called when the window for window manager has appeared
          },

          // This is called after the app is initialized
          // If you return a future, the app will wait for it to complete
          onPostInit: () {
            // This is where you can run code after the app is initialized
            // This happens right before sign in starts
          },

          // This is called after the user signs in but before the home screen
          onAuthenticatedInit: (uid) async {},

          // This is called after sign in and the home screen is entered
          onLaunchComplete: () async {}),

      // This is where you define the user provider
      // this is so it can sign you in and deal with the annoyances of firebase
      // and sign in providers.
      users: ArcaneUserProvider(
        // This defines where the user document is (create on sign up)
        userRef: (uid) => "user/$uid".doc,

        // This defines where the user capabilities document is (create on sign up)
        // This is supposed to be a document that allows creation of self-id but
        // It cannot be modified by the user after creation
        userCapabilitiesRef: (uid) => "user/$uid/data/capabilities".doc,

        // This defines where the user private document is (create on sign up)
        // This is supposed to be a document that allows creation of self-id
        // This is for user settings.
        userPrivateRef: (uid) => "user/$uid/data/private".doc,

        // This is called when a user is created provide the data to create
        onCreateUserCapabilities: (u) => {},

        // This is called when a user is created provide the data to create
        onCreateUserPrivate: (u) => {},

        // This is called when a user is created provide the data to create
        onCreateUser: (u) => {
          "firstName": u.firstName,
          "lastName": u.lastName,
          "email": u.email,
          "uid": u.uid,
        },

        // Called when the user object is changed via stream
        onUserUpdate: (user) {},

        // Called when the user capabilities object is changed via stream
        onUserCapabilitiesUpdate: (userCapabilities) {},

        // Called when the user private object is changed via stream
        onUserPrivateUpdate: (userPrivate) {},
      ),

      // Define themes
      darkTheme: ThemeData.dark(),
      lightTheme: ThemeData.light(),

      // Theme Mods. These are applied to both light and dark themes
      themeMods: [
        // Changes color scheme primary to red
        (t) => t.copyWith(
            colorScheme: t.colorScheme.copyWith(primary: Colors.red)),
      ],

      // These are applied lightTheme -> themeMods -> lightThemeMods
      lightThemeMods: [
        // force white theme card color to pitch white
        (t) => t.copyWith(cardColor: Colors.white)
      ],

      // These are applied darkTheme -> themeMods -> darkThemeMods
      darkThemeMods: [],

      // App title defined here
      title: "Example",

      // For window manager, you can turn this off to "hide" on close
      exitWindowOnClose: true,

      // Override default window options for window manager
      // most of these are already defined
      // but you can override whatever you want here
      windowOptions: const WindowOptions(size: Size(800, 600), center: true),

      // For sign in with windows google
      windowsGoogleSignInClientId: "YOUR_GOOGLE_SIGN_IN_CLIENT_ID",
      windowsGoogleSignInRedirectUri: "YOUR_GOOGLE_SIGN_IN_REDIRECT_URI",

      // This is where you finally create the application object itself
      application: () => ArcaneApp(
        foregroundBuilder: (context, child) => child,

        // Define your home screen
        home: () => const HomeScreen(),
      ),
    );

// Some service that will run when arcane starts before the app runs
class MyAppService extends StatelessService {}

// A basic home screen. Note the ArcaneStatelessScreen it extends
class HomeScreen extends ArcaneStatelessScreen {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
                onPressed: () =>
                    const SettingsScreen().open(context), // open arcane screens
                icon: const Icon(Icons.settings))
          ],
        ),
      );

  // We override toPath to let the router know where to find this screen
  @override
  String toPath() => "/";
}

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

// This arcane screen has a parameter the license key
// We need to do the following to make this parameter work:
// 1. Define the toPath() method to include the license field as /settings/license?license=<LICENSE> so we can GO to it
// 2. Define the buildRoute() method to build the screen based on a url such as /settings/license?license=MIT as LicenseViewerScreen(license: "MIT")
class LicenseViewerScreen extends ArcaneStatelessScreen {
  final String license;

  const LicenseViewerScreen({super.key, required this.license});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("License"),
        ),
        body: Text(licenseTexts[license] ?? "Unknown license"),
      );

  // Step 1. We need to use withParams to add our params.
  @override
  String toPath() => withParams("/settings/license", {
        "license": license,
      });

  // Step 2. We need to map the query params to the license key
  @override
  ArcaneRoute buildRoute({List<ArcaneRoute> subRoutes = const []}) =>
      ArcaneRoute(
        // Use toRegistryPath here
        path: toRegistryPath(),
        // Build our screen with the params
        builder: buildWithParams(
            (params) => LicenseViewerScreen(license: params["license"]!)),
        // Pass along subroutes
        routes: subRoutes,
      );
}

const Map<String, String> licenseTexts = {
  "MIT": "MIT License text",
  "Apache": "Apache License text",
  "GPL": "GPL License text",
};
