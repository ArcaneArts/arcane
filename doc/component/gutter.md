# Gutter

The Gutter components provide a way to add responsive horizontal padding to widgets, adjusting the space automatically based on screen width. This helps create layouts that adapt well to different device sizes with minimal code.

## Components

### GutterTheme

A theme class that defines how gutters should be calculated based on screen width.

#### Constructor

```dart
const GutterTheme({
  double Function(double screenWidth) gutterCalc = _defaultGutterCalc,
  bool enabled = true
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `gutterCalc` | `double Function(double screenWidth)` | Function that calculates the gutter width based on screen width |
| `enabled` | `bool` | Whether gutters are enabled by default |

#### Methods

| Method | Description |
|--------|-------------|
| `copyWith({...})` | Creates a copy of this GutterTheme with the given fields replaced |

### Gutter

A widget that adds responsive horizontal padding to its child widget.

#### Constructor

```dart
const Gutter({
  Key? key,
  required Widget child,
  bool enabled = true
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `child` | `Widget` | The widget to which the horizontal padding will be applied |
| `enabled` | `bool` | Whether the gutter padding is enabled |

### SliverGutter

A widget that adds responsive horizontal padding to a sliver widget for use in sliver-based scrolling layouts.

#### Constructor

```dart
const SliverGutter({
  Key? key,
  required Widget sliver,
  bool enabled = true
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `sliver` | `Widget` | The sliver widget to which the horizontal padding will be applied |
| `enabled` | `bool` | Whether the gutter padding is enabled |

## Default Gutter Calculation

The default gutter calculation function (`_defaultGutterCalc`) uses the following logic:
- For very small screens, minimal gutters are applied
- As screen width increases, gutters grow proportionally
- Gutters are capped at 1/3 of the screen width to ensure content has enough room
- The calculation is: `max(0, min(max(0, 25 + ((screenWidth * 0.25) - 250)), screenWidth / 3))`

## Usage Examples

### Basic Gutter

```dart
Gutter(
  child: Text("This text will have responsive horizontal padding"),
)
```

### Gutter with Content Container

```dart
Gutter(
  child: Container(
    color: Colors.blue.shade100,
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Header", style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: 8),
        Text("This content container will have responsive horizontal margins that adjust based on screen width."),
      ],
    ),
  ),
)
```

### Disabling Gutter

```dart
Gutter(
  enabled: false, // No gutter padding will be applied
  child: Container(
    width: double.infinity,
    color: Colors.red,
    padding: EdgeInsets.all(16),
    child: Text("This will extend to the full width of its parent"),
  ),
)
```

### With CustomScrollView and Slivers

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      title: Text("Sliver Example"),
      floating: true,
    ),
    SliverGutter(
      sliver: SliverToBoxAdapter(
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text("This card has responsive horizontal gutters"),
          ),
        ),
      ),
    ),
    SliverGutter(
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ListTile(
            title: Text("Item $index"),
          ),
          childCount: 20,
        ),
      ),
    ),
  ],
)
```

### Customizing Gutter Theme

```dart
// In your ArcaneTheme configuration
ArcaneTheme(
  gutter: GutterTheme(
    // Custom gutter calculation function
    gutterCalc: (screenWidth) => screenWidth * 0.1, // 10% of screen width
    enabled: true,
  ),
  // Other theme properties...
)

// Now all Gutter widgets will use this calculation by default
```

## Implementation Details

- The Gutter widget internally uses `PaddingHorizontal` to apply the calculated padding
- The SliverGutter widget internally uses `SliverPadding` to apply the calculated padding
- The calculation is performed using the `MediaQuery` to get the current screen width
- The gutter value is applied to both left and right sides equally

## Notes

- For consistent layout across your app, use Gutter for your main content containers
- Gutters help maintain readability by ensuring text lines don't get too wide on large screens
- The default calculation provides a good balance for most applications, but can be customized to suit specific design requirements
- Use SliverGutter when working with sliver-based layouts like CustomScrollView
