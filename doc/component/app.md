# ArcaneApp

ArcaneApp is the main entry point for Arcane applications. It serves as a wrapper around Flutter's material app, providing Arcane-specific theming, navigation, and other app-level configurations.

## Overview

ArcaneApp integrates with the Shadcn design system and provides a consistent foundation for building applications with the Arcane framework. It handles:

- Application theming with ArcaneTheme
- Navigation (both standard and router-based)
- Scrolling behavior
- Locale configurations
- Debug information and performance overlays
- Browser configurations for web applications

## Setup

The `runApp` function initializes and runs an Arcane application:

```dart
import 'package:arcane/arcane.dart';

void main() {
  runApp(
    ArcaneApp(
      home: HomeScreen(),
      theme: ArcaneTheme(),
      title: 'My Arcane App',
    ),
  );
}
```

The `runApp` function handles several setup tasks:
- Sets up debug utilities
- Loads all Arcane shaders
- Configures SEO metadata for web applications

## Standard Navigation

The default constructor for ArcaneApp uses Flutter's standard navigation system with routes and a navigator:

```dart
ArcaneApp(
  home: HomeScreen(),
  routes: {
    '/profile': (context) => ProfileScreen(),
    '/settings': (context) => SettingsScreen(),
  },
  initialRoute: '/',
  navigatorObservers: [MyNavigatorObserver()],
)
```

Key navigation properties:
- `home`: The widget displayed at the root route ('/')
- `routes`: A map of route names to widget builders
- `initialRoute`: The route displayed when the app is first loaded
- `onGenerateRoute`: A function for handling dynamic routes
- `navigatorKey`: A key for accessing the navigator directly
- `navigatorObservers`: A list of objects that observe navigation events

## Router-based Navigation

For more advanced routing capabilities, use the `ArcaneApp.router` constructor:

```dart
ArcaneApp.router(
  routerDelegate: MyRouterDelegate(),
  routeInformationParser: MyRouteInformationParser(),
  routeInformationProvider: MyRouteInformationProvider(),
)
```

This constructor uses Flutter's Router API, which provides:
- More control over route transitions
- Deep linking support
- Better web integration with browser history
- The ability to handle complex routing scenarios

## App State Management

ArcaneApp maintains a state object (`ArcaneAppState`) that provides methods for managing the application at a global level:

```dart
// Access the app state from anywhere
final appState = Arcane.$app;

// Update the app's theme
appState.setTheme(ArcaneTheme(
  primaryColor: Colors.purple,
  darkMode: true,
));

// Force a rebuild of the entire application
appState.updateApp();
```

The app state is automatically stored in the `Arcane.$app` static variable during initialization, making it accessible from anywhere in the application.

## Changing Themes

You can change the app's theme at runtime using the `setTheme` method:

```dart
// Get the current app state
final appState = Arcane.$app;

// Change to a dark theme
appState.setTheme(ArcaneTheme(darkMode: true));

// Change to a light theme with a custom primary color
appState.setTheme(ArcaneTheme(
  darkMode: false,
  primaryColor: Colors.deepPurple,
));
```

The current theme is also accessible through the `currentTheme` getter:

```dart
final currentTheme = Arcane.$app.currentTheme;
final isDarkMode = currentTheme.darkMode;
```

## Scrolling Behavior

ArcaneApp uses `ArcaneScrollBehavior` to provide a consistent scrolling experience across platforms and input devices:

```dart
ArcaneScrollBehavior(
  allowMouseDragging: true, // Allow scrolling with mouse drag
)
```

Features of `ArcaneScrollBehavior`:
- Uses bouncing scroll physics for a consistent feel across platforms
- Enables scrolling with mouse drag by default
- Supports all pointer device types (touch, stylus, trackpad, etc.)

## Example Usage

### Basic Application

```dart
import 'package:arcane/arcane.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    ArcaneApp(
      title: 'My Arcane App',
      home: HomeScreen(),
      theme: ArcaneTheme(
        darkMode: true,
        primaryColor: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FillScreen(
      title: 'Home',
      body: Center(
        child: Text('Welcome to Arcane!'),
      ),
    );
  }
}
```

### Router-based Navigation

```dart
import 'package:arcane/arcane.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    ArcaneApp.router(
      title: 'Router-based Arcane App',
      routerDelegate: MyRouterDelegate(),
      routeInformationParser: MyRouteInformationParser(),
      theme: ArcaneTheme(),
    ),
  );
}

// Example router delegate implementation
class MyRouterDelegate extends RouterDelegate<RouteConfiguration> {
  // Implementation details...
}

// Example route information parser
class MyRouteInformationParser extends RouteInformationParser<RouteConfiguration> {
  // Implementation details...
}
```

## Advanced Configuration

ArcaneApp provides many configuration options inherited from Flutter's MaterialApp:

- `disableBrowserContextMenu`: Disable the browser's context menu in web applications
- `showPerformanceOverlay`: Display performance statistics overlay
- `debugShowCheckedModeBanner`: Show or hide the debug banner
- `shortcuts`: Define keyboard shortcuts for the application
- `supportedLocales`: Define the locales supported by the application
- `localizationsDelegates`: Provide delegates for localizing the application
- `scaling`: Control how UI elements adapt to different screen sizes
