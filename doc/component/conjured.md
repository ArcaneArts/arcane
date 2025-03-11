# Conjured Components

The Conjured components provide a set of utility widgets for displaying data models that implement the `Conjured` interface. These components make it easy to create consistent UI elements from your data models with minimal boilerplate.

## Overview

The Conjured component system consists of five main components:

- **CTitle**: Displays the title from a model implementing ConjuredTitle
- **CSubtitle**: Displays the subtitle from a model implementing ConjuredSubtitle
- **CBasic**: Provides a structured layout for displaying Conjured model data
- **CCard**: Wraps a Conjured model in a Card component
- **CListTile**: Displays a Conjured model as a list tile

These components work together to help you quickly create UI elements from your data models with consistent styling and behavior.

## CTitle

`CTitle` displays the title from a model implementing the ConjuredTitle interface.

### Constructor

```dart
const CTitle({
  Key? key,
  required T model,
});
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `model` | `T extends ConjuredTitle` | The model containing the title to display |

## CSubtitle

`CSubtitle` displays the subtitle from a model implementing the ConjuredSubtitle interface.

### Constructor

```dart
const CSubtitle({
  Key? key,
  required T model,
});
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `model` | `T extends ConjuredSubtitle` | The model containing the subtitle to display |

## CBasic

`CBasic` provides a structured layout for Conjured models using the Basic component.

### Constructor

```dart
const CBasic({
  Key? key,
  required T model,
  Widget? leading,
  Widget? title,
  Widget? subtitle,
  Widget? content,
  Widget? trailing,
  AlignmentGeometry? leadingAlignment,
  AlignmentGeometry? trailingAlignment,
  AlignmentGeometry? titleAlignment,
  AlignmentGeometry? subtitleAlignment,
  AlignmentGeometry? contentAlignment,
  double? contentSpacing,
  double? titleSpacing,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
  EdgeInsetsGeometry? padding,
});
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `model` | `T extends Conjured` | The model to display |
| `leading` | `Widget?` | Widget to display at the start |
| `title` | `Widget?` | Custom title widget (if not provided, uses CTitle if model implements ConjuredTitle) |
| `subtitle` | `Widget?` | Custom subtitle widget (if not provided, uses CSubtitle if model implements ConjuredSubtitle) |
| `content` | `Widget?` | Main content widget |
| `trailing` | `Widget?` | Widget to display at the end |
| `leadingAlignment` | `AlignmentGeometry?` | Alignment for the leading widget |
| `trailingAlignment` | `AlignmentGeometry?` | Alignment for the trailing widget |
| `titleAlignment` | `AlignmentGeometry?` | Alignment for the title widget |
| `subtitleAlignment` | `AlignmentGeometry?` | Alignment for the subtitle widget |
| `contentAlignment` | `AlignmentGeometry?` | Alignment for the content widget |
| `contentSpacing` | `double?` | Space between content and title/subtitle |
| `titleSpacing` | `double?` | Space between title and subtitle |
| `mainAxisAlignment` | `MainAxisAlignment` | Main axis alignment for the layout |
| `padding` | `EdgeInsetsGeometry?` | Padding around the entire component |

## CCard

`CCard` wraps a Conjured model in a Card component.

### Constructor

```dart
const CCard({
  Key? key,
  required T model,
  VoidCallback? onPressed,
});
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `model` | `T extends Conjured` | The model to display in the card |
| `onPressed` | `VoidCallback?` | Function to call when the card is tapped |

## CListTile

`CListTile` displays a Conjured model as a list tile.

### Constructor

```dart
const CListTile({
  Key? key,
  required T model,
  VoidCallback? onPressed,
  Widget? leading,
  Widget? trailing,
});
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `model` | `T extends Conjured` | The model to display in the list tile |
| `onPressed` | `VoidCallback?` | Function to call when the tile is tapped |
| `leading` | `Widget?` | Widget to display at the start of the tile |
| `trailing` | `Widget?` | Widget to display at the end of the tile |

## Usage Examples

### Displaying a User Model

First, define your data model:

```dart
class User implements ConjuredTitle, ConjuredSubtitle {
  final String name;
  final String email;

  User({required this.name, required this.email});

  @override
  String? get title => name;

  @override
  String? get subtitle => email;
}
```

Then use the Conjured components to display it:

```dart
// Using CCard
CCard(
  model: User(name: "John Doe", email: "john@example.com"),
  onPressed: () => print("Card tapped"),
)

// Using CListTile
CListTile(
  model: User(name: "John Doe", email: "john@example.com"),
  leading: CircleAvatar(child: Text("JD")),
  trailing: Icon(Icons.chevron_right),
  onPressed: () => print("Tile tapped"),
)

// Using CBasic with custom content
CBasic(
  model: User(name: "John Doe", email: "john@example.com"),
  leading: CircleAvatar(child: Text("JD")),
  content: Column(
    children: [
      Text("Member since: 2023"),
      LinearProgressIndicator(value: 0.7),
      Text("Level: 7"),
    ],
  ),
)
```

## Notes

- The Conjured components automatically detect if your model implements ConjuredTitle or ConjuredSubtitle
- You can override the automatic title/subtitle display by providing custom title/subtitle widgets
- These components help maintain consistency when displaying the same data model in different UI contexts
- For more complex display needs, extend the base components or create custom widgets
