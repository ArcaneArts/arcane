import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_service.dart';
import 'package:arcane/feature/service/hive_service.dart';
import 'package:arcane/feature/service/logging_service.dart';
import 'package:arcane/feature/service/user_service.dart';
import 'package:arcane/feature/service/widgets_binding_service.dart';
import 'package:arcane/feature/service/window_service.dart';
import 'package:common_svgs/common_svgs.dart';
import 'package:dialoger/dialoger.dart';
import 'package:hive/hive.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:window_manager/window_manager.dart';

late final Arcane _app;

typedef FireDoc = DocumentReference<Map<String, dynamic>>;
typedef FireDocProvider = FireDoc Function(String uid);

class ArcaneUserInfo {
  final String firstName;
  final String lastName;
  final String email;
  final String uid;

  ArcaneUserInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.uid,
  });
}

class ArcaneUserProvider {
  final FireDocProvider userRef;
  final FireDocProvider userCapabilitiesRef;
  final FireDocProvider userPrivateRef;

  final Map<String, dynamic> Function(ArcaneUserInfo info) onCreateUser;
  final Map<String, dynamic> Function(ArcaneUserInfo info)
      onCreateUserCapabilities;
  final Map<String, dynamic> Function(ArcaneUserInfo info) onCreateUserPrivate;
  final Function(Map<String, dynamic> user)? onUserUpdate;
  final Function(Map<String, dynamic> userCapabilities)?
      onUserCapabilitiesUpdate;
  final Function(Map<String, dynamic> userPrivate)? onUserPrivateUpdate;

  ArcaneUserProvider({
    required this.userRef,
    required this.userCapabilitiesRef,
    required this.userPrivateRef,
    required this.onCreateUser,
    required this.onCreateUserCapabilities,
    required this.onCreateUserPrivate,
    this.onUserUpdate,
    this.onUserCapabilitiesUpdate,
    this.onUserPrivateUpdate,
  });
}

class ArcanePlatform {
  static get web => kIsWeb;
  static get debug => kDebugMode;
  static get profile => kProfileMode;
  static get release => kReleaseMode;
  static get ios => !web && Platform.isIOS;
  static get android => !web && Platform.isAndroid;
  static get macos => !web && Platform.isMacOS;
  static get windows => !web && Platform.isWindows;
  static get linux => !web && Platform.isLinux;
  static get fuchsia => !web && Platform.isFuchsia;
  static get cores => web ? 1 : Platform.numberOfProcessors;
}

class ArcaneEvents {
  final Function()? onPreInit;
  final Function()? onPostInit;
  final Function(String uid)? onAuthenticatedInit;
  final Function()? onLaunchComplete;
  final Function()? onWindowManagerShown;

  ArcaneEvents({
    this.onPreInit,
    this.onPostInit,
    this.onAuthenticatedInit,
    this.onLaunchComplete,
    this.onWindowManagerShown,
  });
}

class Arcane {
  final String title;
  final bool exitWindowOnClose;
  final WindowOptions windowOptions;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ArcaneApp Function() application;
  final FirebaseOptions firebase;
  final ArcaneEvents? events;
  final ArcaneUserProvider users;
  final String svgLogo;
  final ArcaneRouter router;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final List<ThemeMod> themeMods;
  final List<ThemeMod> darkThemeMods;
  final List<ThemeMod> lightThemeMods;
  final String? windowsGoogleSignInClientId;
  final String? windowsGoogleSignInRedirectUri;
  BuildContext? _tempContext;
  Opal? _opalController;

  Arcane({
    required this.title,
    this.exitWindowOnClose = true,
    required this.router,
    required this.firebase,
    required this.application,
    required this.users,
    this.windowOptions = const WindowOptions(
      size: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.hidden,
    ),
    this.svgLogo = svgArcaneArts,
    this.events,
    this.windowsGoogleSignInClientId,
    this.windowsGoogleSignInRedirectUri,
    this.lightTheme,
    this.darkTheme,
    this.themeMods = const [],
    this.darkThemeMods = const [],
    this.lightThemeMods = const [],
  }) {
    _app = this;
    _start();
  }

  bool get canSignInWithGoogleOnWindows =>
      windowsGoogleSignInClientId != null &&
      windowsGoogleSignInRedirectUri != null;

  Future<void> _start() async {
    await _registerDefaultServices();
    await _init(events?.onPreInit);
    await services().waitForStartup();
    await _init(events?.onPostInit);
  }

  Future<void> _init(Function()? run) async {
    var m = run;
    if (m != null) {
      await m();
    }
  }

  Future<void> _registerDefaultServices() async {
    services().register<LoggingService>(() => LoggingService(), lazy: false);
    services().register<WidgetsBindingService>(() => WidgetsBindingService(),
        lazy: false);
    services().register<HiveService>(() => HiveService(), lazy: false);
    services().register<UserService>(() => UserService());
    services().register<LoginService>(() => LoginService());

    if (isWindowManaged) {
      services().register<WindowService>(() => WindowService(), lazy: false);
    }
  }

  void updateTempContext(BuildContext context) => _tempContext = context;

  static String get uid => svc<UserService>().uid();

  static void signOut() => dialogConfirm(
      context: context,
      title: "Sign Out?",
      description: "Are you sure you want to sign out?",
      confirmButtonText: "Sign Out",
      onConfirm: (context) {
        svc<LoginService>().signOut().then((value) {
          Navigator.pushNamedAndRemoveUntil(
              context, "/splash", (route) => false);
        });
      });

  static GlobalKey<NavigatorState> get navKey => app.navigatorKey;

  static CollectionReference<Map<String, dynamic>> collection(String name) =>
      FirebaseFirestore.instance.collection(name);

  static GoRouter buildRouterConfig() => app.router.buildConfiguration(navKey);

  static void goHome(BuildContext context) =>
      context.go(app.router.initialRoute);

  static void goSplash(BuildContext context) => context.go("/splash");

  static void goLogin(BuildContext context) => context.go("/login");

  static Talker get logger => talker;

  static Arcane get app => _app;

  static bool get isWindowManaged =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

  static BuildContext get context =>
      navKey.currentContext ?? _app._tempContext!;

  static ThemeMode get themeMode =>
      ThemeMode.values
          .where((element) =>
              element.index ==
              box.get('_arcane_themeMode',
                  defaultValue: ThemeMode.system.index))
          .firstOrNull ??
      ThemeMode.system;

  static set themeMode(ThemeMode mode) {
    box.put('_arcane_themeMode', mode.index);
    opal.themeMode.value = mode;
  }

  static Box get box => svc<HiveService>().dataBox;

  static LazyBox get cache => svc<HiveService>().cacheBox;

  static Opal get opal => _app._opalController!;

  static void dropSplash() => svc<WidgetsBindingService>().dropSplash();

  static void rebirth() => Arcane(
        title: app.title,
        router: app.router,
        users: app.users,
        firebase: app.firebase,
        application: app.application,
        events: app.events,
        svgLogo: app.svgLogo,
      );

  void updateOpalController(Opal controller) => _opalController = controller;
}
