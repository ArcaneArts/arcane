# Gesture Components

The Gesture components provide a set of utilities for handling various touch and mouse interactions in a clean and declarative way. The system includes two main components (`OnGesture` and `OnHover`) and extension methods for easily adding gesture handlers to any widget.

## Components

### GestureType

An enum that defines the different types of gestures that can be detected.

```dart
enum GestureType {
  press,
  secondaryPress,
  tertiaryPress,
  longPress,
  longSecondaryPress,
  longTertiaryPress,
  doublePress,
}
```

| Value | Description |
|-------|-------------|
| `press` | Primary tap/click (left click on desktop) |
| `secondaryPress` | Secondary tap/click (right click on desktop) |
| `tertiaryPress` | Tertiary tap/click (middle click on desktop) |
| `longPress` | Long press with primary button |
| `longSecondaryPress` | Long press with secondary button |
| `longTertiaryPress` | Long press with tertiary button |
| `doublePress` | Double tap/click |

### OnGesture

A widget that detects a specific gesture type and executes an action when it occurs.

#### Constructor

```dart
const OnGesture({
  Key? key,
  required GestureType type,
  required Widget child,
  HitTestBehavior? behavior,
  Set<PointerDeviceKind>? supportedDevices,
  required VoidCallback action
});
```

#### Named Constructors

```dart
const OnGesture.press({...});
const OnGesture.secondaryPress({...});
const OnGesture.tertiaryPress({...});
const OnGesture.longPress({...});
const OnGesture.longSecondaryPress({...});
const OnGesture.longTertiaryPress({...});
const OnGesture.doublePress({...});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `type` | `GestureType` | The type of gesture to detect |
| `child` | `Widget` | The widget that will receive the gesture |
| `behavior` | `HitTestBehavior?` | How to behave during hit testing |
| `supportedDevices` | `Set<PointerDeviceKind>?` | The types of input devices that can trigger this gesture |
| `action` | `VoidCallback` | The function to call when the gesture is detected |

### OnHover

A widget that detects mouse hover and executes an action when hover state changes.

#### Constructor

```dart
const OnHover({
  Key? key,
  required void Function(bool hovering) action,
  required Widget child
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `action` | `Function(bool hovering)` | Function called with true when hover begins and false when it ends |
| `child` | `Widget` | The widget to detect hover over |

## Extension Methods

The library provides convenient extension methods on widgets for adding gesture handlers:

```dart
// Primary press (tap/click)
Widget onPressed(VoidCallback action, {...})

// Secondary press (right click)
Widget onSecondaryPressed(VoidCallback action, {...})

// Tertiary press (middle click)
Widget onTertiaryPressed(VoidCallback action, {...})

// Long press with primary button
Widget onLongPressed(VoidCallback action, {...})

// Long press with secondary button
Widget onLongSecondaryPressed(VoidCallback action, {...})

// Long press with tertiary button
Widget onLongTertiaryPressed(VoidCallback action, {...})

// Double press (double tap/click)
Widget onDoublePressed(VoidCallback action, {...})

// Hover detection
Widget onHover(void Function(bool hovering) action)
```

Each method has optional parameters for `behavior` and `supportedDevices`.

## Usage Examples

### Basic Press/Tap Handling

```dart
Text("Tap me")
  .onPressed(() => print("Text was tapped"))
```

### Multiple Gesture Types

```dart
Container(
  width: 200,
  height: 100,
  color: Colors.blue,
  child: Center(child: Text("Interact with me"))
)
  .onPressed(() => print("Normal tap"))
  .onSecondaryPressed(() => print("Right click"))
  .onLongPressed(() => print("Long press"))
  .onDoublePressed(() => print("Double tap"))
```

### Hover Effects

```dart
// Using extension method
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text("Hover over me"),
  ),
).onHover((isHovering) {
  if (isHovering) {
    print("Card is being hovered");
  } else {
    print("Hover ended");
  }
})

// Using OnHover widget
OnHover(
  action: (hovering) {
    setState(() => _isHovered = hovering);
  },
  child: Container(
    color: _isHovered ? Colors.blue : Colors.grey,
    padding: EdgeInsets.all(20),
    child: Text("Hover to change color"),
  ),
)
```

### With HitTestBehavior

```dart
Stack(
  children: [
    Image.network("https://example.com/image.jpg"),
    Positioned.fill(
      child: Text("Tap here")
        .onPressed(
          () => print("Text tapped"),
          behavior: HitTestBehavior.translucent,
        ),
    ),
  ],
)
```

### Limiting to Specific Device Types

```dart
Text("Mouse click only")
  .onPressed(
    () => print("Clicked with mouse"),
    supportedDevices: {PointerDeviceKind.mouse},
  )
```

## Implementation Details

- The components use Flutter's `GestureDetector` widget internally
- For hover detection, `MouseRegion` is used
- The extension methods make it easy to chain multiple gesture handlers on a single widget

## Notes

- When adding multiple gesture handlers to a widget, be aware of potential conflicts (e.g., between press and double press)
- For more complex gesture recognition (like drag, scale, etc.), use Flutter's built-in gesture detectors
- These utilities are designed for simple tap/click interactions and hover detection
