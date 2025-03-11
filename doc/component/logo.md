# ArcaneArtsLogo

The `ArcaneArtsLogo` component provides a simple way to display the Arcane Arts logo in your application. It renders the logo as an SVG with customizable size and color.

## Features

- **Scalable Vector Graphics**: Logo is rendered as an SVG for crisp display at any size
- **Customizable Size**: Set the logo size to fit your layout needs
- **Customizable Color**: Optionally override the default color of the logo

## Constructor

```dart
const ArcaneArtsLogo({
  Key? key,
  double size = 32,
  Color? color,
});
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `size` | `double` | The width and height of the logo (default: 32) |
| `color` | `Color?` | Optional color override for the logo |

## Usage Examples

### Basic Logo Display

```dart
ArcaneArtsLogo()
```

### Custom Size

```dart
ArcaneArtsLogo(
  size: 64,
)
```

### Custom Color

```dart
ArcaneArtsLogo(
  size: 48,
  color: Colors.blue,
)
```

### In an AppBar

```dart
AppBar(
  title: Row(
    children: [
      ArcaneArtsLogo(size: 24),
      SizedBox(width: 8),
      Text("Arcane App"),
    ],
  ),
)
```

### As a Loading Indicator

```dart
Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ArcaneArtsLogo(
        size: 72,
        color: Theme.of(context).primaryColor,
      ),
      SizedBox(height: 16),
      Text("Loading..."),
    ],
  ),
)
```

## Implementation Details

- Uses the `flutter_svg` package to render the SVG
- The SVG data is loaded from the `common_svgs` package
- When a color is provided, it is applied using a `ColorFilter` with `BlendMode.srcIn`
- The logo maintains a square aspect ratio, with both width and height set to the `size` parameter

## Notes

- For best results, use sizes that are multiples of 8 (8, 16, 24, 32, etc.)
- The default size of 32 is appropriate for most UI contexts like headers and navigation areas
- When using as a prominent feature (splash screens, about pages), consider larger sizes (64-128)
- If no color is specified, the logo will use its default colors
- For light/dark theme support, you may want to change the color based on the current theme
