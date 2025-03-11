# IconButton

The `IconButton` component provides a customizable button with an icon as its primary content. It offers a variety of styles, shapes, and behaviors to match your application's design needs.

## Features

- **Multiple Variants**: Primary, secondary, outline, ghost, link, text, and destructive styles
- **Customizable Sizing**: Control the size and density of the button
- **Shape Options**: Different shape styles (rectangle, rounded, circle)
- **Event Handling**: Support for various tap/click interactions including long press
- **Visual Feedback**: Hover and focus states for enhanced user interaction

## Constructor

```dart
const IconButton({
  Key? key,
  required Widget icon,
  ButtonVariance variance = ButtonVariance.ghost,
  VoidCallback? onPressed,
  bool? enabled,
  Widget? leading,
  Widget? trailing,
  AlignmentGeometry? alignment,
  ButtonSize size = ButtonSize.normal,
  ButtonDensity density = ButtonDensity.icon,
  ButtonShape shape = ButtonShape.rectangle,
  FocusNode? focusNode,
  bool disableTransition = false,
  ValueChanged<bool>? onHover,
  ValueChanged<bool>? onFocus,
  bool trailingExpanded = false,
  bool? enableFeedback,
  GestureTapDownCallback? onTapDown,
  GestureTapUpCallback? onTapUp,
  GestureTapCancelCallback? onTapCancel,
  GestureTapDownCallback? onSecondaryTapDown,
  GestureTapUpCallback? onSecondaryTapUp,
  GestureTapCancelCallback? onSecondaryTapCancel,
  GestureTapDownCallback? onTertiaryTapDown,
  GestureTapUpCallback? onTertiaryTapUp,
  GestureTapCancelCallback? onTertiaryTapCancel,
  GestureLongPressStartCallback? onLongPressStart,
  GestureLongPressUpCallback? onLongPressUp,
  GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
  GestureLongPressEndCallback? onLongPressEnd,
  GestureLongPressUpCallback? onSecondaryLongPress,
  GestureLongPressUpCallback? onTertiaryLongPress,
});
```

## Named Constructors

The IconButton widget provides several named constructors for different button styles:

```dart
const IconButton.primary({...}); // Primary colored button
const IconButton.secondary({...}); // Secondary colored button
const IconButton.outline({...}); // Outlined button
const IconButton.ghost({...}); // Ghost button (minimal styling)
const IconButton.link({...}); // Link-styled button
const IconButton.text({...}); // Text-styled button
const IconButton.destructive({...}); // Destructive/danger button
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `icon` | `Widget` | The icon to display in the button |
| `variance` | `ButtonVariance` | The style variant of the button |
| `onPressed` | `VoidCallback?` | Function to call when the button is pressed |
| `enabled` | `bool?` | Whether the button is enabled |
| `leading` | `Widget?` | Widget to display before the icon |
| `trailing` | `Widget?` | Widget to display after the icon |
| `alignment` | `AlignmentGeometry?` | Alignment of the button content |
| `size` | `ButtonSize` | Size of the button (small, normal, large) |
| `density` | `ButtonDensity` | Density/padding of the button |
| `shape` | `ButtonShape` | Shape of the button (rectangle, rounded, circle) |
| `focusNode` | `FocusNode?` | Focus node for controlling button focus |
| `disableTransition` | `bool` | Whether to disable transition animations |
| `onHover` | `ValueChanged<bool>?` | Function called when hover state changes |
| `onFocus` | `ValueChanged<bool>?` | Function called when focus state changes |
| `trailingExpanded` | `bool` | Whether the trailing widget should expand |
| `enableFeedback` | `bool?` | Whether to enable tap feedback |
| Various tap/press callbacks | Various | For handling different gesture events |

## Usage Examples

### Basic Icon Button

```dart
IconButton(
  icon: Icon(Icons.favorite),
  onPressed: () => print("Favorite button pressed"),
)
```

### Different Button Variants

```dart
Column(
  children: [
    IconButton.primary(
      icon: Icon(Icons.save),
      onPressed: () => saveData(),
    ),
    SizedBox(height: 8),
    IconButton.secondary(
      icon: Icon(Icons.refresh),
      onPressed: () => refreshData(),
    ),
    SizedBox(height: 8),
    IconButton.outline(
      icon: Icon(Icons.share),
      onPressed: () => shareContent(),
    ),
    SizedBox(height: 8),
    IconButton.destructive(
      icon: Icon(Icons.delete),
      onPressed: () => deleteItem(),
    ),
  ],
)
```

### Icon Button with Leading and Trailing Content

```dart
IconButton(
  icon: Icon(Icons.play_arrow),
  leading: Text("Play"),
  trailing: Text("Now"),
  onPressed: () => playMedia(),
  variance: ButtonVariance.primary,
  size: ButtonSize.large,
)
```

### Different Shapes and Sizes

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    IconButton(
      icon: Icon(Icons.add),
      shape: ButtonShape.rectangle,
      size: ButtonSize.small,
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.add),
      shape: ButtonShape.rounded,
      size: ButtonSize.normal,
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.add),
      shape: ButtonShape.circle,
      size: ButtonSize.large,
      onPressed: () {},
    ),
  ],
)
```

### Handling Multiple Gestures

```dart
IconButton(
  icon: Icon(Icons.touch_app),
  onPressed: () => print("Pressed"),
  onLongPress: () => print("Long pressed"),
  onSecondaryTap: () => print("Right clicked"),
  onHover: (hovering) => print("Hover state: $hovering"),
)
```

## Button Variance

The `ButtonVariance` enum defines different style variants for the button:

- `primary`: The main action style, using the primary color
- `secondary`: A less emphasized action style
- `outline`: A button with an outline/border
- `ghost`: A minimal button with no background until hovered
- `link`: Styled like a hyperlink
- `text`: Minimal styling, just like text
- `destructive`: For actions that delete or can't be undone

## Button Size

The `ButtonSize` enum defines the overall size of the button:

- `small`: A smaller button for compact UIs
- `normal`: Standard size (default)
- `large`: Larger button for emphasis or touch targets

## Button Density

The `ButtonDensity` enum defines the internal padding/density of the button:

- `icon`: Minimal padding for icon-only buttons
- `iconComfortable`: Slightly more padding for icon-only buttons
- `compact`: Compact padding for text and icons
- `default`: Standard padding
- `comfortable`: Extra padding for a more comfortable touch target

## Implementation Details

- IconButton is built on top of the base Button component
- The internal Button component manages states like hover, focus, and press
- The button applies appropriate themes based on the variant selected
- Icons receive sizing based on the button size
- When using Text as the icon, it is automatically styled with appropriate sizing

## Notes

- For icon-only buttons, use the `ButtonDensity.icon` density
- For buttons with both text and icons, consider using the standard Button component instead
- The ghost variant is often used for toolbar buttons or actions in cards
- For destructive actions, prefer the destructive variant to provide visual cues
