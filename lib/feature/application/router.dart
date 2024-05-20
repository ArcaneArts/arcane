import 'dart:convert';

import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_service.dart';
import 'package:arcane/feature/login/screen/login.dart';
import 'package:arcane/feature/login/screen/splash.dart';
import 'package:arcane/feature/service/user_service.dart';
import 'package:arcane/feature/service/widgets_binding_service.dart';

typedef ArcaneRoute = GoRoute;

typedef ArcaneRouterWidgetBuilder = GoRouterWidgetBuilder;

class ArcaneRouter {
  final String initialRoute;
  final List<dynamic> routes;
  final GoRouterRedirect? redirect;

  const ArcaneRouter({
    this.redirect,
    this.initialRoute = '/',
    this.routes = const [],
  });

  GoRouter buildConfiguration(GlobalKey<NavigatorState> key) => GoRouter(
        navigatorKey: key,
        initialLocation: initialRoute,
        routes: [
          ...routes.map(_buildRoute),
          _buildRoute(const LoginScreen()),
          _buildRoute(const SplashScreen())
        ],
        redirect: (context, state) {
          String uri = state.uri.toString();
          if ((!svc<LoginService>().isSignedIn() ||
                  !svc<UserService>().bound) &&
              !(uri.startsWith("/splash") || uri.startsWith("/login"))) {
            return LoginScreen(redirect: uri).toPath();
          }

          if (svc<LoginService>().isSignedIn() && uri.startsWith("/login")) {
            return const SplashScreen().toPath();
          }

          svc<WidgetsBindingService>().dropIfUp();
          return redirect?.call(context, state);
        },
      );

  static ArcaneRoute _buildRoute(
    dynamic route, {
    List<dynamic> children = const [],
  }) {
    if (route is ArcaneRoute) {
      return route;
    } else if (route is ArcaneRoutingScreen) {
      return route.buildRoute(subRoutes: children.map(_buildRoute).toList());
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

  String toRegistryPath() {
    String path = toPath();

    // Strip out query params
    if (path.contains("?")) {
      path = path.split("?").first;
    }

    // Get registry key only
    if (path.contains("/")) {
      path = path.split("/").last;
    }

    return path;
  }

  ArcaneRoute buildRoute({List<ArcaneRoute> subRoutes = const []}) =>
      ArcaneRoute(
        path: toRegistryPath(),
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
