# Icons

The `Icons` class provides a comprehensive collection of icons from multiple icon libraries, unified under a single consistent API. It combines icons from Phosphor Icons, Ionicons, and Material Icons, making it easy to access thousands of icons without needing to remember which library they come from.

## Overview

The Arcane Icons system:
- Provides a single access point for multiple icon libraries
- Maintains consistent naming conventions
- Offers various icon styles and weights
- Works seamlessly with other Arcane components

## Icon Sources

The `Icons` class combines icons from the following sources:
- **Phosphor Icons**: A flexible icon family with consistent style
- **Ionicons**: High-quality icon pack often used in mobile applications
- **Material Icons**: Google's Material Design icons

## Usage

To use an icon, simply reference it through the `Icons` class:

```dart
Icon(Icons.home)
```

The icons can be used in any widget that accepts an `IconData` parameter, such as:
- `Icon` widget
- `IconButton`
- `ListTile.leading` or `ListTile.trailing`
- Many other components that display icons

## Icon Styles

Phosphor Icons included in this library come in different styles, which are indicated by a suffix in the icon name:

- No suffix: Regular weight
- `_thin`: Thinner stroke weight
- `_light`: Light stroke weight
- `_bold`: Bold stroke weight
- `_fill`: Filled version of the icon

## Examples

### Using Icons in Different Components

```dart
// Basic icon usage
Icon(Icons.heart)

// Using icons in buttons
IconButton(
  icon: Icon(Icons.favorite),
  onPressed: () => print("Favorite"),
)

// Using icons in list tiles
ListTile(
  leading: Icon(Icons.person),
  title: Text("Profile"),
  trailing: Icon(Icons.chevron_right),
)

// Using icons with different sizes and colors
Icon(
  Icons.star_fill,
  size: 32,
  color: Colors.amber,
)
```

### Using Different Icon Weights

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Icon(Icons.heart_thin),   // Thin weight
    Icon(Icons.heart),        // Regular weight
    Icon(Icons.heart_bold),   // Bold weight
    Icon(Icons.heart_fill),   // Filled version
  ],
)
```

## Icon Categories

Icons are organized by their use case and functionality. Some common categories include:

- **Navigation**: Icons for navigation controls (arrows, menu, etc.)
- **Actions**: Icons representing actions (save, delete, share, etc.)
- **Objects**: Icons representing physical objects
- **Social**: Icons for social media platforms
- **Communication**: Icons related to communication (email, chat, etc.)
- **Media**: Icons for media controls and types
- **Alerts**: Icons for notifications and alerts
- **Maps & Location**: Icons for maps, directions, and locations
- **UI Controls**: Icons for user interface elements

## Material Icons Alias

For compatibility with existing code, Material Icons are also available through the `MaterialIcons` type alias:

```dart
// These are equivalent
Icon(Icons.add)
Icon(MaterialIcons.add)
```

## Best Practices

- Use icons consistently throughout your application
- Choose icons that clearly convey their meaning
- Consider using the same weight of icons throughout a single screen
- For important actions, consider using colored icons to draw attention
- Use appropriate sizes based on context (toolbars vs. primary actions)
- When in doubt about which icon to use, refer to common UX patterns

## Notes

- The full set of icons is extensive, with thousands of options available
- For performance reasons, only import the `Icons` class rather than individual icons
- When using many icons in a scrolling list, consider caching the widgets to improve performance
- The icon set is designed to work at various sizes, but some detailed icons may not render well at very small sizes
