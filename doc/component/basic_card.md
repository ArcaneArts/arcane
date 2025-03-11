# BasicCard

`BasicCard` is a wrapper widget that combines the functionality of `Card` and `Basic` components to create styled cards with structured content. It provides a convenient way to create cards with title, subtitle, leading, trailing, and content sections.

## Features

- **Flexible Layout**: Combine leading icon/image with title, subtitle, and content
- **Customizable Styling**: Control padding, colors, borders, shadows, and more
- **Touch Interactivity**: Optional `onPressed` callback for touch events
- **Structural Alignment**: Control alignment of each content section independently

## Constructor

```dart
const BasicCard({
  Key? key,
  EdgeInsetsGeometry? padding,
  bool filled = false,
  Color? fillColor,
  BorderRadiusGeometry? borderRadius,
  Color? borderColor,
  double? borderWidth,
  Clip clipBehavior = Clip.none,
  List<BoxShadow>? boxShadow,
  double? surfaceOpacity,
  double? surfaceBlur,
  Duration? duration,
  VoidCallback? onPressed,
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
  EdgeInsetsGeometry? basicPadding,
});
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `padding` | `EdgeInsetsGeometry?` | Padding around the entire card |
| `filled` | `bool` | Whether the card has a filled background |
| `fillColor` | `Color?` | Background color of the card |
| `borderRadius` | `BorderRadiusGeometry?` | Radius of the card's corners |
| `borderColor` | `Color?` | Color of the card's border |
| `borderWidth` | `double?` | Width of the card's border |
| `clipBehavior` | `Clip` | How to clip content that overflows the card |
| `boxShadow` | `List<BoxShadow>?` | Shadow effects applied to the card |
| `surfaceOpacity` | `double?` | Opacity of the card's surface |
| `surfaceBlur` | `double?` | Blur amount for the card's background |
| `duration` | `Duration?` | Duration for card animations |
| `onPressed` | `VoidCallback?` | Function called when the card is tapped |
| `leading` | `Widget?` | Widget displayed at the start of the card |
| `title` | `Widget?` | Main title widget |
| `subtitle` | `Widget?` | Subtitle widget displayed below the title |
| `content` | `Widget?` | Main content of the card |
| `trailing` | `Widget?` | Widget displayed at the end of the card |
| `leadingAlignment` | `AlignmentGeometry?` | Alignment for the leading widget |
| `trailingAlignment` | `AlignmentGeometry?` | Alignment for the trailing widget |
| `titleAlignment` | `AlignmentGeometry?` | Alignment for the title widget |
| `subtitleAlignment` | `AlignmentGeometry?` | Alignment for the subtitle widget |
| `contentAlignment` | `AlignmentGeometry?` | Alignment for the content widget |
| `contentSpacing` | `double?` | Space between content and title/subtitle |
| `titleSpacing` | `double?` | Space between title and subtitle |
| `mainAxisAlignment` | `MainAxisAlignment` | Main axis alignment for the card content |
| `basicPadding` | `EdgeInsetsGeometry?` | Padding applied to the inner Basic widget |

## Usage Examples

### Simple Card with Title and Content

```dart
BasicCard(
  title: Text("Card Title"),
  content: Text("This is the content of the card with more details."),
  onPressed: () => print("Card was tapped"),
)
```

### Card with Leading Icon and Subtitle

```dart
BasicCard(
  leading: Icon(Icons.star),
  title: Text("Featured Item"),
  subtitle: Text("Special offer available"),
  content: Text("Get 20% off on this item today!"),
  borderRadius: BorderRadius.circular(8),
  filled: true,
  fillColor: Colors.blue.shade50,
)
```

### Styled Card with Custom Alignments

```dart
BasicCard(
  leading: CircleAvatar(
    backgroundImage: NetworkImage("https://example.com/avatar.png"),
  ),
  leadingAlignment: Alignment.topCenter,
  title: Text("User Profile"),
  titleAlignment: Alignment.centerLeft,
  subtitle: Text("Premium Member"),
  content: Column(
    children: [
      Text("Bio information and other details about the user"),
      SizedBox(height: 8),
      LinearProgressIndicator(value: 0.7),
    ],
  ),
  trailing: IconButton(
    icon: Icon(Icons.edit),
    onPressed: () => print("Edit profile"),
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ],
  borderRadius: BorderRadius.circular(12),
)
```

## Related Components

- `Card`: The base card component used by BasicCard for styling
- `Basic`: Used internally to structure the content of the card
- `Tile`: A similar component for list items
- `ListTile`: A standard list tile component with similar layout

## Notes

- BasicCard is primarily a convenience widget that combines Card and Basic widgets
- For more control over the card content structure, you can use Card and Basic separately
- The content will expand to fill available space, while leading and trailing widgets maintain their natural size
