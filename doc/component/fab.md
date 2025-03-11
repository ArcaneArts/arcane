# Floating Action Button Components

The Floating Action Button (FAB) components provide a set of widgets for adding action buttons to your UI that appear to float above the main content. These components include `Fab`, `FabMenu`, `FabGroup`, and `FabSocket`, each serving different interaction patterns.

## Components

### Fab

A basic floating action button with built-in styling.

#### Constructor

```dart
const Fab({
  Key? key,
  required Widget child,
  Widget? leading,
  VoidCallback? onPressed,
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `child` | `Widget` | The content of the button (usually an icon or text) |
| `leading` | `Widget?` | Optional widget to display before the main content |
| `onPressed` | `VoidCallback?` | Function to call when the button is pressed |

### FabMenu

A floating action button that displays a dropdown menu when pressed.

#### Constructor

```dart
const FabMenu({
  Key? key,
  required Widget child,
  Widget? leading,
  List<MenuItem> items = const [],
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `child` | `Widget` | The content of the button |
| `leading` | `Widget?` | Optional widget to display before the main content |
| `items` | `List<MenuItem>` | List of menu items to display when the button is pressed |

### FabGroup

A floating action button that displays a group of related buttons when pressed.

#### Constructor

```dart
const FabGroup({
  Key? key,
  required Widget child,
  Widget? leading,
  required List<Widget> Function(BuildContext) children,
  bool horizontal = false,
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `child` | `Widget` | The content of the main button |
| `leading` | `Widget?` | Optional widget to display before the main content |
| `children` | `List<Widget> Function(BuildContext)` | Function that returns the list of buttons to display when opened |
| `horizontal` | `bool` | Whether to display the child buttons horizontally (true) or vertically (false) |

### FabSocket

A container that positions a FAB in the bottom-right corner of its parent widget.

#### Constructor

```dart
const FabSocket({
  Key? key,
  required Widget child,
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `child` | `Widget` | The FAB to be positioned (typically a `Fab`, `FabMenu`, or `FabGroup`) |

## Usage Examples

### Basic Floating Action Button

```dart
FabSocket(
  child: Fab(
    child: Icon(Icons.add),
    onPressed: () => print("FAB pressed"),
  ),
)
```

### Floating Action Button with Menu

```dart
FabSocket(
  child: FabMenu(
    child: Text("Options"),
    leading: Icon(Icons.more_vert),
    items: [
      MenuItem(
        label: "New Document",
        onPressed: () => createNewDocument(),
        icon: Icon(Icons.description),
      ),
      MenuItem(
        label: "New Folder",
        onPressed: () => createNewFolder(),
        icon: Icon(Icons.folder),
      ),
      MenuItem(
        label: "Upload File",
        onPressed: () => uploadFile(),
        icon: Icon(Icons.upload_file),
      ),
    ],
  ),
)
```

### Floating Action Button with Button Group

```dart
FabSocket(
  child: FabGroup(
    child: Icon(Icons.add),
    horizontal: true,
    children: (context) => [
      Fab(
        child: Icon(Icons.person_add),
        onPressed: () => addContact(),
      ),
      Fab(
        child: Icon(Icons.photo_camera),
        onPressed: () => takePhoto(),
      ),
      Fab(
        child: Icon(Icons.note_add),
        onPressed: () => addNote(),
      ),
    ],
  ),
)
```

### In a Scaffold

```dart
Scaffold(
  body: Center(
    child: Text("Content here"),
  ),
  floatingActionButton: Fab(
    child: Icon(Icons.add),
    onPressed: () => showAddDialog(context),
  ),
)
```

## Features

- **Styled Appearance**: FABs come with a pre-styled appearance with blur effects
- **Menu Support**: Easy creation of menu-based FABs
- **Button Groups**: Support for groups of related actions
- **Positioning**: FabSocket handles positioning in the parent container
- **Blur Effect**: Automatic blur effect for a modern appearance

## Implementation Details

- The `blurIn` extension is used to add a blur effect to the FAB
- FabGroup uses a Popover component to display child buttons
- FabMenu uses a dropdown menu component to display menu items
- Buttons use Ghost Button styling for a clean appearance

## Notes

- You can dismiss a FabGroup programmatically using `context.dismissFabGroup()`
- Text children are automatically styled with large text, and icons are automatically enlarged
- For consistent styling across your app, use the FAB components instead of Flutter's standard FloatingActionButton
