import 'dart:convert';

import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_service.dart';
import 'package:arcane/feature/login/screen/login.dart';
import 'package:arcane/feature/login/screen/splash.dart';
import 'package:arcane/feature/service/user_service.dart';
import 'package:arcane/feature/service/widgets_binding_service.dart';

typedef ArcaneRoute = GoRoute;

typedef ArcaneRouterWidgetBuilder = GoRouterWidgetBuilder;

class OpalObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      Arcane.opal.setBackgroundSeed(previousRoute!.settings.name ?? "/");
    }
  }
}

class ArcaneRouter {
  final String initialRoute;
  final List<dynamic> routes;
  final GoRouterRedirect? redirect;
  final List<NavigatorObserver> observers;

  const ArcaneRouter({
    this.redirect,
    this.initialRoute = '/',
    this.observers = const [],
    this.routes = const [],
  });

  GoRouter buildConfiguration(GlobalKey<NavigatorState> key) {
    try {
      return GoRouter(
        navigatorKey: key,
        initialLocation: "/splash",
        observers: [],
        routes: [
          ...routes.map(_buildRoute),
          _buildRoute(const LoginScreen(), topLevel: true),
          _buildRoute(const SplashScreen(), topLevel: true)
        ],
        redirect: (context, state) async {
          String uri = state.uri.toString();
          bool signedIn = svc<LoginService>().isSignedIn();
          bool bound = svc<UserService>().bound;

          verbose("Signed In: $signedIn, Bound: $bound, URI: $uri");

          if ((!signedIn || !bound) &&
              !(uri.startsWith("/splash") || uri.startsWith("/login"))) {
            verbose(
                "Redirect: $uri -> ${SplashScreen(redirect: uri).toPath()}");
            return SplashScreen(redirect: uri).toPath();
          }

          if (signedIn && uri.startsWith("/login")) {
            verbose("Redirect: $uri -> ${const SplashScreen().toPath()}");
            return const SplashScreen().toPath();
          }

          Arcane.opal.setBackgroundSeed(state.uri.toString());
          svc<WidgetsBindingService>().dropIfUp();
          String? s = await redirect?.call(context, state);
          if (s != null) {
            verbose("Redirect: $uri -> $s");
          }
          return s;
        },
      )..logRouter();
    } catch (e, es) {
      error(e);
      error(es);
    }

    throw Exception("Failed to build router");
  }

  static ArcaneRoute _buildRoute(
    dynamic route, {
    List<dynamic> children = const [],
    bool topLevel = false,
  }) {
    if (route is ArcaneRoute) {
      return route;
    } else if (route is ArcaneRoutingScreen) {
      return route.buildRoute(
          subRoutes: children.map(_buildRoute).toList(), topLevel: topLevel);
    } else {
      throw Exception(
          'Invalid route type. Expected either ArcaneRoute, ArcaneStatelessScreen or ArcaneStatefulScreen');
    }
  }
}

abstract class ArcaneStatefulScreen extends StatefulWidget
    with ArcaneRoutingScreen {
  const ArcaneStatefulScreen({super.key});
}

abstract class ArcaneStatelessScreen extends StatelessWidget
    with ArcaneRoutingScreen {
  const ArcaneStatelessScreen({super.key});
}

mixin ArcaneRoutingScreen {
  /// Define a path that this screen resolves to. This is used to navigate to this path.
  /// The path should start with a / typically. If your screen is /a/b, then you must define
  /// your router with a hierarchy that matches this path such as
  /// / -> HomeScreen(), children: [
  ///   a -> AScreen(), children: [
  ///     b -> THISScreen()
  /// ]
  ///
  /// You also need to convert all of your fields in this class into a string that can be used
  /// In your route definition you will also have to convert that path back into this screen object
  String toPath();

  String toRegistryPath({bool topLevel = false}) {
    String path = toPath();

    if (path.trim() == "/") {
      return "/";
    }

    // Strip out query params
    if (path.contains("?")) {
      path = path.split("?").first;
    }

    // Get registry key only
    if (path.contains("/")) {
      path = path.split("/").last;
    }

    return "${topLevel ? "/" : ""}$path";
  }

  ArcaneRoute buildRoute(
          {List<ArcaneRoute> subRoutes = const [], bool topLevel = false}) =>
      ArcaneRoute(
        path: toRegistryPath(topLevel: topLevel),
        builder: (context, state) => this as Widget,
        routes: subRoutes,
      );

  ArcaneRouterWidgetBuilder buildWithParams(
          Widget Function(Map<String, String> params) builder) =>
      (_, s) => builder(s.uri.queryParameters);

  // Reset the entire navigation stack to the path of this screen.
  // If the user hits the back button in ui they will go up the path, NOT go back to the previous screen
  // If the user hits the browser back button they will go back to the previous ROUTE they were at (browser history)
  void open(BuildContext context) => context.go(toPath());

  String withParams(String path, Map<String, String> params) => Uri(
        path: path,
        queryParameters: params,
      ).toString();

  ArcaneRoute subRoute(List<dynamic> subRoutes) => ArcaneRoute(
        path: toRegistryPath(),
        builder: (context, state) => this as Widget,
        routes: subRoutes.map(ArcaneRouter._buildRoute).toList(),
      );
}

extension XStringRedirectConverter on String {
  String get toRedirect => base64Url.encode(utf8.encode(this));
  String get fromRedirect => utf8.decode(base64Url.decode(this));
}

extension XGoRouter on GoRouter {
  void logRouter() {
    for (RouteBase m in configuration.routes) {
      if (m is GoRoute) {
        m.logRoute();
      } else {
        verbose("Route: $m");
      }
    }
  }
}

extension XGoRoute on GoRoute {
  void logRoute([int depth = 0]) {
    verbose("${" " * depth}ArcaneRoute: $path");
    for (RouteBase m in routes) {
      if (m is GoRoute) {
        m.logRoute(depth + 1);
      } else {
        verbose("${" " * (depth + 1)}Route: $m");
      }
    }
  }
}
