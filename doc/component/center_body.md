# CenterBody

`CenterBody` is a simple utility component that displays an icon, an optional message, and an optional action button centered on the screen. It's commonly used for empty states, error messages, or simple informational displays.

## Features

- **Centered Layout**: All content is centered on the screen for clear visibility
- **Icon Display**: Prominently displays an icon to represent the state
- **Optional Message**: Can include a text message to explain the state
- **Optional Action Button**: Can include a button for user interaction

## Constructor

```dart
const CenterBody({
  Key? key,
  required IconData icon,
  String? message,
  String? actionText,
  VoidCallback? onActionPressed,
});
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `icon` | `IconData` | The icon to display at the center of the screen |
| `message` | `String?` | Optional text message to display below the icon |
| `actionText` | `String?` | Optional text for the action button |
| `onActionPressed` | `VoidCallback?` | Function to call when the action button is pressed |

## Usage Examples

### Empty State Display

```dart
CenterBody(
  icon: Icons.inbox,
  message: "No messages found",
  actionText: "Refresh",
  onActionPressed: () => refreshMessages(),
)
```

### Error State

```dart
CenterBody(
  icon: Icons.error_outline,
  message: "Failed to load data",
  actionText: "Try Again",
  onActionPressed: () => loadData(),
)
```

### Simple Information Display

```dart
CenterBody(
  icon: Icons.check_circle,
  message: "Operation completed successfully",
)
```

### In a Scaffold

```dart
Scaffold(
  appBar: AppBar(title: Text("My App")),
  body: CenterBody(
    icon: Icons.search,
    message: "No search results found",
    actionText: "Clear Search",
    onActionPressed: () => clearSearch(),
  ),
)
```

## Implementation Details

- The component uses a `Column` with `MainAxisSize.min` to ensure it takes up only the needed space
- The icon is displayed with a size of 56 pixels for visibility
- A standard gap of 16 pixels is included between the icon and the message
- If an action button is provided, it's separated from the message by an 8-pixel gap
- The component is wrapped in a `Center` widget to position it in the middle of the available space

## Best Practices

- Use clear, recognizable icons that represent the state or action
- Keep message text concise and informative
- Use action buttons for common operations that users might want to perform
- Consider using different icons for different types of states (empty, error, success, etc.)

## Notes

- This component works well in both full-screen contexts and within smaller container widgets
- For more complex layouts, consider using a custom solution instead
