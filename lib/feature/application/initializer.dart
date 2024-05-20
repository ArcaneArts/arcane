import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_service.dart';
import 'package:arcane/feature/service/hive_service.dart';
import 'package:arcane/feature/service/logging_service.dart';
import 'package:arcane/feature/service/user_service.dart';
import 'package:arcane/feature/service/widgets_binding_service.dart';
import 'package:dialoger/dialoger.dart';
import 'package:hive/hive.dart';
import 'package:talker_flutter/talker_flutter.dart';

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

  ArcaneEvents({
    this.onPreInit,
    this.onPostInit,
    this.onAuthenticatedInit,
    this.onLaunchComplete,
  });
}

class Arcane {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ArcaneApp Function() application;
  final FirebaseOptions firebase;
  final ArcaneEvents? events;
  final ArcaneUserProvider users;
  final String? svgLogo;
  final ArcaneRouter router;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final List<ThemeMod> themeMods;
  final List<ThemeMod> darkThemeMods;
  final List<ThemeMod> lightThemeMods;
  BuildContext? _tempContext;

  Arcane({
    required this.router,
    required this.firebase,
    required this.application,
    required this.users,
    this.svgLogo,
    this.events,
    this.lightTheme,
    this.darkTheme,
    this.themeMods = const [],
    this.darkThemeMods = const [],
    this.lightThemeMods = const [],
  }) {
    _app = this;
    _start();
  }

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

  static set themeMode(ThemeMode mode) =>
      box.put('_arcane_themeMode', mode.index);

  static Box get box => svc<HiveService>().dataBox;

  static LazyBox get cache => svc<HiveService>().cacheBox;

  static void dropSplash() => svc<WidgetsBindingService>().dropSplash();

  static void rebirth() => Arcane(
        router: app.router,
        users: app.users,
        firebase: app.firebase,
        application: app.application,
        events: app.events,
        svgLogo: app.svgLogo,
      );
}

String arcaneArtsLogo = '''
<svg xmlns="http://www.w3.org/2000/svg" width="8192" height="8192"><path fill="#5F47FF" d="m4439 3102 2 1a332 332 0 0 1 37 30l18 18a14743 14743 0 0 0 13 13l11 11a56077 56077 0 0 1 198 198l2 1a1587272 1587272 0 0 1 1039 1040l1 2a2169101 2169101 0 0 1 247 246l2 2a469498 469498 0 0 1 200 200l1 1a3240 3240 0 0 0 27 28 225 225 0 0 1 60 137 214 214 0 0 1-69 152l-11 12-2 2a1084 1084 0 0 1-33 33l-2 2-10 9-15 15a11749 11749 0 0 1-12 12l-9 9a44504 44504 0 0 0-130 130l-3 3a3033716 3033716 0 0 1-43 43l-2 2a1225932 1225932 0 0 0-97 97l-2 2a1561595 1561595 0 0 1-178 178l-2 2-106 105-1 2a21269507 21269507 0 0 0-344 344l-5 5a39406154 39406154 0 0 0-534 534l-2 2a26969261 26969261 0 0 0-33 33l-3 3-5 5-4 5-6 6-17 16-5 5-4 5-6 6c-7 5-13 12-19 18a26339 26339 0 0 1-35 35l-17 18-14 14a19035 19035 0 0 0-48 47l-3 3a293 293 0 0 1-48 33 176 176 0 0 1-176 2l-2-1-31-20-2-1a291 291 0 0 1-45-40l-14-14-18-19a18548 18548 0 0 1-143-145c-34-39-58-91-55-144a179 179 0 0 1 8-38 227 227 0 0 1 45-82 325 325 0 0 1 20-22l25-26a29664 29664 0 0 0 19-19l14-14 22-22 2-2 2-2a2298 2298 0 0 0 62-61l7-8 9-8 7-8 9-8 7-8 9-8 10-10 22-23a27064 27064 0 0 0 19-19l13-13a90949 90949 0 0 1 234-234l2-2 100-100 2-2 4-4 2-2 1-1a2346 2346 0 0 0 43-43l2-2a5139 5139 0 0 1 73-72l26-27a25961 25961 0 0 0 43-43l118-118a749 749 0 0 0 31-31l13-14 3-2 8-8 8-8a30089 30089 0 0 1 146-146l2-2 11-10 7-8 9-8 7-8 9-8 9-10 13-13a492 492 0 0 0 46-45 16716 16716 0 0 1 48-49l15-19 1-2c31-42 51-92 43-144-2-15-6-30-12-44l-1-3c-10-21-21-40-36-58l-2-3a339 339 0 0 0-33-36c-6-6-12-13-19-18a264 264 0 0 1-23-23l-8-7a29384 29384 0 0 1-105-106l-2-2a2276005 2276005 0 0 0-98-98l-2-2a1520396 1520396 0 0 0-162-162l-3-3-84-84-3-3a23153429 23153429 0 0 1-266-266l-3-2-84-85-3-3a5221784 5221784 0 0 1-161-161l-3-3-2-2a856435 856435 0 0 1-95-95l-2-2a253399 253399 0 0 0-121-121l-3-2-13-15-2-2c-36-43-63-95-59-152a218 218 0 0 1 58-122 560 560 0 0 1 50-53l11-11 18-18 2-2 2-2 4-4 4-4 7-7 7-7a6430 6430 0 0 0 5-5l3-3a61688 61688 0 0 1 76-76l7-5 19-16 2-1c21-17 45-30 70-38l2-1c56-17 114-2 160 31Z"/><path fill="#5F47FF" d="m3958 1285 2 1a244 244 0 0 1 33 21 291 291 0 0 1 45 40l14 14 18 19a18548 18548 0 0 1 143 145c34 39 58 91 55 144-1 12-4 24-7 36l-1 2c-8 29-24 56-43 79l-2 3a325 325 0 0 1-20 22l-25 26a29664 29664 0 0 0-19 19l-14 14-22 22-2 2-2 2a2298 2298 0 0 0-62 61l-7 8-9 8-7 8-9 8-7 8-9 8-10 10-22 23a27064 27064 0 0 0-19 19l-13 13a90949 90949 0 0 1-234 234l-2 2-100 100-2 2-4 4-2 2-1 1a2346 2346 0 0 0-43 43l-2 2a5139 5139 0 0 1-73 72l-26 27a25961 25961 0 0 0-43 43l-118 118a749 749 0 0 0-31 31l-13 14-3 2-8 8-8 8a30089 30089 0 0 1-146 146l-2 2-11 10-7 8-9 8-7 8-9 8-9 10-13 13a492 492 0 0 0-46 45 16716 16716 0 0 1-48 49l-15 19-1 2c-31 42-51 92-43 144 2 15 6 30 12 44l1 3c10 21 21 40 36 58l2 3a339 339 0 0 0 33 36c6 6 12 13 19 18l13 13 3 2 7 8 8 7a29384 29384 0 0 1 105 106l2 2a2276005 2276005 0 0 0 95 95l3 3 2 2a1520396 1520396 0 0 0 162 162l3 3 84 84 3 3a23153429 23153429 0 0 1 266 266l3 2 84 85 3 3a5221784 5221784 0 0 1 261 261l2 2a253399 253399 0 0 0 121 121l3 2 13 15 2 2c36 43 63 95 59 152a218 218 0 0 1-58 122 560 560 0 0 1-50 53l-11 11-18 18-2 2-2 2-4 4-4 4-7 7-7 7a6430 6430 0 0 0-5 5l-3 3a61688 61688 0 0 1-62 62l-2 2-12 12-7 5-19 16-2 1c-21 17-45 30-70 38l-2 1c-44 14-90 7-131-13-10-6-20-11-29-18l-2-1a332 332 0 0 1-37-30l-18-18a14743 14743 0 0 0-13-13l-11-11a56077 56077 0 0 1-198-198l-2-1a1587272 1587272 0 0 1-194-195l-2-2a12534065 12534065 0 0 0-843-843l-1-2a2169101 2169101 0 0 1-195-194l-2-2a2270824 2270824 0 0 0-50-50l-2-2a469498 469498 0 0 1-200-200l-1-1a3240 3240 0 0 0-27-28c-33-38-57-83-60-134v-3a214 214 0 0 1 69-152l11-12 2-2a1084 1084 0 0 1 33-33l2-2 10-9 15-15 3-3 9-9 9-9a44504 44504 0 0 0 130-130l3-3a3033716 3033716 0 0 1 43-43l2-2a1225932 1225932 0 0 0 97-97l2-2a1561595 1561595 0 0 1 178-178l2-2 106-105 1-2a21269507 21269507 0 0 0 344-344l5-5a39406154 39406154 0 0 0 534-534l2-2a26969262 26969262 0 0 0 33-33l3-3 5-5 4-5 6-6 17-16 5-5 4-5 6-6c7-5 13-12 19-18a26339 26339 0 0 1 35-35l17-18 14-14a19035 19035 0 0 0 48-47l3-3a293 293 0 0 1 48-33c56-32 120-33 176-2Z"/></svg>
''';
