# Glass Components

The Glass components provide a set of widgets for creating frosted glass/blur effects in your UI. These components include `Glass` for applying blur effects, `GlassStopper` for controlling when the effect is applied, and `GlassAntiFlicker` for handling edge cases.

## Components

### Glass

The main component that applies a blur effect to its child widget with a semi-transparent background.

#### Constructor

```dart
const Glass({
  Key? key,
  bool ignoreContextSignals = false,
  Color? disabledColor,
  Widget? under,
  Color? tint,
  bool disabled = false,
  double? blur,
  BorderRadius borderRadius = const BorderRadius.all(Radius.circular(0)),
  required Widget child
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `ignoreContextSignals` | `bool` | Whether to ignore glass stopping signals from parent context |
| `disabledColor` | `Color?` | Background color to use when glass effect is disabled |
| `under` | `Widget?` | Widget to display underneath the glass effect |
| `tint` | `Color?` | Color tint to apply to the glass effect |
| `disabled` | `bool` | Whether to disable the glass effect |
| `blur` | `double?` | Blur amount (if null, uses theme's surfaceBlur) |
| `borderRadius` | `BorderRadius` | Border radius for clipping the glass effect |
| `child` | `Widget` | The widget to which the glass effect is applied |

### GlassStopper

A component that controls whether glass effects should be applied to child components. This allows for selectively disabling glass effects in specific parts of the UI.

#### Constructor

```dart
const GlassStopper({
  Key? key,
  required Widget Function(BuildContext context) builder,
  bool stopping = false
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `builder` | `Widget Function(BuildContext context)` | Builder function for the content |
| `stopping` | `bool` | Whether to stop glass effects in descendant widgets |

#### Static Methods

| Method | Description |
|--------|-------------|
| `static bool isStopping(BuildContext context)` | Checks if a GlassStopper in the widget tree is stopping glass effects |

### GlassAntiFlicker

A component that helps prevent flickering at the edges of glass effects by applying a gradient.

#### Constructor

```dart
const GlassAntiFlicker({
  Key? key,
  required AntiFlickerDirection direction
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `direction` | `AntiFlickerDirection` | The direction of the anti-flicker gradient |

### AntiFlickerDirection

An enum that defines the directions for the anti-flicker gradient.

```dart
enum AntiFlickerDirection {
  top,
  bottom,
  left,
  right
}
```

## Usage Examples

### Basic Glass Effect

```dart
Glass(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text("This text is behind glass"),
  ),
)
```

### Styled Glass Card

```dart
Glass(
  borderRadius: BorderRadius.circular(12),
  tint: Colors.blue.withOpacity(0.1),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, size: 32),
        SizedBox(height: 8),
        Text("Important Information", style: TextStyle(fontSize: 18)),
        SizedBox(height: 8),
        Text("This card has a frosted glass effect with a blue tint"),
      ],
    ),
  ),
)
```

### With Content Underneath

```dart
Stack(
  children: [
    Image.network("https://example.com/background.jpg"),
    Positioned.fill(
      child: Glass(
        blur: 10,
        tint: Colors.black.withOpacity(0.2),
        child: Center(
          child: Text(
            "Blurred Background",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    ),
  ],
)
```

### Selective Glass Effect Disabling

```dart
GlassStopper(
  stopping: true,
  builder: (context) => Column(
    children: [
      Text("This area has glass effects disabled"),
      SizedBox(height: 16),
      // This Glass component's effect will be disabled
      Glass(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("This won't have a glass effect"),
        ),
      ),
    ],
  ),
)
```

### Preventing Edge Flickering

```dart
Stack(
  children: [
    // Content
    Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Glass(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("Glass panel at bottom"),
        ),
      ),
    ),
    // Anti-flicker gradient at the top edge of the glass
    Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 20,
      child: GlassAntiFlicker(direction: AntiFlickerDirection.top),
    ),
  ],
)
```

## Implementation Details

- The Glass component uses SurfaceBlur internally to create the blur effect
- GlassStopper uses a Pylon to share its state with descendant widgets
- The glass effect is disabled when GlassStopper.isStopping(context) returns true, unless ignoreContextSignals is set to true
- When disabled, the glass effect is replaced with a solid background color
- The anti-flicker direction specifies where the gradient should fade from (e.g., AntiFlickerDirection.top creates a gradient that fades from top to bottom)

## Notes

- For the best visual effect, apply glass effects over content or backgrounds with some variation in color or texture
- The blur amount can be customized, but higher values may impact performance
- Use GlassStopper when you want to disable glass effects in specific parts of your UI, such as when displaying content that needs maximum clarity
- The GlassAntiFlicker component is useful for preventing visual artifacts at the edges of glass panels
