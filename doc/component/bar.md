# Bar

`Bar` is a customizable app bar component that provides a flexible interface for creating headers in your application. It supports leading and trailing widgets, title, subtitle, custom header and footer components, and includes built-in features like back button handling and glass effects.

## Features

- **Leading and Trailing Widgets**: Add custom widgets to the left and right sides of the bar
- **Title and Subtitle**: Display text or custom widgets as the title and subtitle
- **Header and Footer**: Add additional content above or below the main bar
- **Back Button**: Configurable back button behavior
- **Glass Effect**: Optional glass-like blur effect for a modern UI
- **Customizable Styling**: Control height, padding, background color, and more

## Constructor

```dart
const Bar({
  Key? key,
  this.ignoreContextSignals = false,
  this.trailing = const [],
  this.leading = const [],
  this.titleText,
  this.backButton = BarBackButtonMode.always,
  this.headerText,
  this.subtitleText,
  this.title,
  this.actions,
  this.header,
  this.subtitle,
  this.child,
  this.trailingExpanded = false,
  this.alignment = Alignment.center,
  this.padding,
  this.backgroundColor,
  this.leadingGap,
  this.trailingGap,
  this.height,
  this.barHeader,
  this.barFooter,
  this.useGlass = true
});
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `trailing` | `List<Widget>` | Widgets displayed at the end (right) of the bar |
| `leading` | `List<Widget>` | Widgets displayed at the start (left) of the bar |
| `child` | `Widget?` | The main content of the bar |
| `title` | `Widget?` | Custom widget to use as the title |
| `barHeader` | `Widget?` | Content displayed above the bar |
| `barFooter` | `Widget?` | Content displayed below the bar |
| `titleText` | `String?` | Text to display as the title |
| `headerText` | `String?` | Text to display above the title |
| `subtitleText` | `String?` | Text to display below the title |
| `header` | `Widget?` | Small widget placed on top of the title |
| `subtitle` | `Widget?` | Small widget placed below the title |
| `trailingExpanded` | `bool` | Whether to expand the trailing section instead of the main content |
| `alignment` | `Alignment` | Alignment of the title content |
| `backgroundColor` | `Color?` | Background color of the bar |
| `leadingGap` | `double?` | Space between leading widgets |
| `trailingGap` | `double?` | Space between trailing widgets |
| `padding` | `EdgeInsetsGeometry?` | Padding around bar content |
| `height` | `double?` | Height of the bar |
| `useGlass` | `bool` | Whether to apply a glass effect to the bar |
| `backButton` | `BarBackButtonMode` | Controls when to show the back button |
| `ignoreContextSignals` | `bool` | Whether to ignore context signals from parent widgets |
| `actions` | `BarActions?` | Collection of action buttons to display in the trailing area |

## BarBackButtonMode

Controls the behavior of the back button:

- `never`: Never show the back button
- `always`: Always show the back button if navigation can pop
- `whenPinned`: Show the back button only when the bar is pinned

## Usage Examples

### Basic Bar with Title

```dart
Bar(
  titleText: "My App",
)
```

### Bar with Back Button and Actions

```dart
Bar(
  titleText: "Details",
  backButton: BarBackButtonMode.always,
  actions: BarActions(
    actions: [
      BarAction(
        icon: Icons.edit,
        label: "Edit",
        onPressed: () => {/* Edit action */},
      ),
      BarAction(
        icon: Icons.delete,
        label: "Delete",
        onPressed: () => {/* Delete action */},
      ),
    ],
  ),
)
```

### Custom Bar with Leading and Trailing Widgets

```dart
Bar(
  titleText: "Dashboard",
  leading: [
    IconButton(
      icon: Icon(Icons.menu),
      onPressed: () => {/* Open drawer */},
    ),
  ],
  trailing: [
    IconButton(
      icon: Icon(Icons.search),
      onPressed: () => {/* Open search */},
    ),
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () => {/* Show notifications */},
    ),
  ],
)
```

### Bar with Header and Footer

```dart
Bar(
  titleText: "Profile",
  barHeader: Container(
    color: Colors.blue.shade100,
    padding: EdgeInsets.all(8),
    child: Text("Premium User"),
  ),
  barFooter: Divider(),
)
```

## Related Classes

### BarActions

`BarActions` provides a flexible way to add multiple action buttons to your bar. It automatically collapses overflow actions into a dropdown menu.

```dart
BarActions(
  actions: [
    BarAction(
      icon: Icons.edit,
      label: "Edit",
      onPressed: () => {/* Edit action */},
      collapsable: true, // Can be collapsed into dropdown menu
    ),
    BarAction(
      icon: Icons.share,
      label: "Share",
      onPressed: () => {/* Share action */},
      collapsable: false, // Will always be shown
    ),
  ],
  maxIcons: 2, // Maximum number of icons to show before collapsing
)
```

### BarAction

Represents a single action button in the bar.

| Parameter | Type | Description |
|-----------|------|-------------|
| `icon` | `IconData` | Icon to display |
| `label` | `String` | Text label for the action (shown in tooltip or menu) |
| `onPressed` | `VoidCallback` | Function to call when the action is triggered |
| `collapsable` | `bool` | Whether this action can be moved to the overflow menu |

## Advanced Features

### Injection

The Bar component supports injection of additional widgets through context using the following classes:

- `InjectBarTrailing`: Inject widgets into the trailing area
- `InjectBarLeading`: Inject widgets into the leading area
- `InjectBarHeader`: Inject a header widget

### SafeBar

The `SafeBar` class helps manage safe areas (notches, cutouts) around the bar:

```dart
SafeBar(
  top: true,
  bottom: false,
  left: true,
  right: true,
  builder: (context) => Bar(
    titleText: "Safe Area Example",
  ),
)
```

### BlockBackButton

The `BlockBackButton` class allows you to temporarily disable the back button:

```dart
BlockBackButton(
  block: true,
  builder: (context) => Bar(
    titleText: "Can't Go Back",
  ),
)
```

## Notes

- The bar automatically handles back navigation when the back button is shown
- The glass effect provides a modern, translucent look but can be disabled
- When using with Scaffold, place the Bar in the appBar property
- For more complex cases, consider using copyWith() to modify an existing Bar
