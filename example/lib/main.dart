import 'package:arcane/arcane.dart';
import 'package:example/firebase_options.dart';

// Start the app by just calling Arcane with the required parameters.
void main() => Arcane(
      // Firebase options are required to initialize the app.
      // This is needed for the Firebase services to work.
      firebase: DefaultFirebaseOptions.currentPlatform,

      // Optionally provide a string representing an svg logo for your login
      // and other places. The [arcaneArtsLogo] is the default
      svgLogo: arcaneArtsLogo,

      // Events are optional and can be used to run code before and after
      // Initialization phases
      events: ArcaneEvents(
          // This is called before the app is initialized
          // Here is where you register services
          // If you return a future, the app will wait for it to complete
          onPreInit: () {
            services().register<MyAppService>(() => MyAppService());
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

      // This is where you finally create the application object itself
      application: () => ArcaneApp(
        // Define your themes. Dont worry about theme system modes
        darkTheme: ThemeData.dark(),
        lightTheme: ThemeData.light(),
        title: "Example",

        // Define your home screen
        home: () => const HomeScreen(),
      ),
    );

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold();
}

class MyAppService extends StatelessService {}
