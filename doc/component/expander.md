# Expander

`Expander` is a component that creates a collapsible container with a header that can be clicked to expand or collapse the content. It's useful for creating accordion-style UI elements, FAQ sections, or any content that needs to be shown or hidden based on user interaction.

## Features

- **Interactive Header**: Clickable header to toggle content visibility
- **Animated Transitions**: Smooth animations when expanding or collapsing
- **Controllable State**: Can be controlled programmatically
- **Flexible Layout**: Customizable alignment and spacing of content
- **Event Signals**: Uses BoxSignal to broadcast expansion events

## Components

### ExpanderController

A controller class that manages the expanded state of an Expander and allows external control.

#### Constructor

```dart
ExpanderController({
  bool initiallyExpanded = false
})
```

#### Methods

| Method | Description |
|--------|-------------|
| `toggle()` | Toggles between expanded and collapsed states |
| `setExpanded(bool value)` | Sets the expansion state to the specified value |

### ExpanderState

A simple state class that represents the current expanded state.

#### Constructor

```dart
ExpanderState(bool expanded)
```

### Expander

The main component that creates the expandable UI element.

#### Constructor

```dart
const Expander({
  Key? key,
  required Widget child,
  required Widget header,
  bool initiallyExpanded = false,
  ExpanderController? controller,
  Duration duration = const Duration(milliseconds: 250),
  Curve curve = Curves.easeOutCirc,
  AlignmentGeometry alignment = Alignment.topCenter,
  Duration reverseDuration = const Duration(milliseconds: 250),
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  double gapPadding = 8,
  Widget? overrideSeparator,
})
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `child` | `Widget` | The content to show when expanded |
| `header` | `Widget` | The always-visible header that toggles expansion |
| `initiallyExpanded` | `bool` | Whether the content is initially expanded |
| `controller` | `ExpanderController?` | Optional controller for external state management |
| `duration` | `Duration` | Duration of the expansion animation |
| `curve` | `Curve` | Animation curve for expansion |
| `alignment` | `AlignmentGeometry` | Alignment of the animated content |
| `reverseDuration` | `Duration` | Duration of the collapse animation |
| `crossAxisAlignment` | `CrossAxisAlignment` | Cross-axis alignment of the content |
| `gapPadding` | `double` | Space between header and expanded content |
| `overrideSeparator` | `Widget?` | Custom widget to show between header and content instead of gap |

## Usage Examples

### Basic Expander

```dart
Expander(
  header: Text("Click to expand", style: TextStyle(fontWeight: FontWeight.bold)),
  child: Padding(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    child: Text("This is the expandable content that will be shown or hidden when the header is clicked."),
  ),
)
```

### Styled Expander with Icon

```dart
Expander(
  header: Row(
    children: [
      Icon(Icons.info_outline),
      SizedBox(width: 8),
      Text("Additional Information", style: TextStyle(fontSize: 16)),
      Spacer(),
      Icon(Icons.keyboard_arrow_down),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Item 1: Some information"),
      Text("Item 2: More details"),
      Text("Item 3: Even more content"),
    ],
  ),
  initiallyExpanded: true,
  curve: Curves.easeInOut,
)
```

### Controlled Expander

```dart
// In a StatefulWidget
late ExpanderController _controller;

@override
void initState() {
  super.initState();
  _controller = ExpanderController(initiallyExpanded: true);
}

// In the build method
Column(
  children: [
    Row(
      children: [
        Text("Control Panel"),
        Spacer(),
        TextButton(
          onPressed: () => _controller.toggle(),
          child: Text("Toggle Content"),
        ),
      ],
    ),
    Expander(
      controller: _controller,
      header: Text("Controlled Section"),
      child: Container(
        height: 200,
        color: Colors.lightBlue.shade50,
        child: Center(
          child: Text("This content is controlled externally"),
        ),
      ),
    ),
  ],
)
```

### FAQ-Style Expandable List

```dart
Column(
  children: [
    Expander(
      header: Text("Question 1: What is Flutter?", 
        style: TextStyle(fontWeight: FontWeight.bold)),
      child: Text("Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase."),
    ),
    Divider(),
    Expander(
      header: Text("Question 2: What is Arcane?",
        style: TextStyle(fontWeight: FontWeight.bold)),
      child: Text("Arcane is a Flutter UI component library providing enhanced widgets for building beautiful applications."),
    ),
    Divider(),
    Expander(
      header: Text("Question 3: How do I use Expander?",
        style: TextStyle(fontWeight: FontWeight.bold)),
      child: Text("Simply provide a header and content child to create an expandable section in your UI."),
    ),
  ],
)
```

## Implementation Details

- Uses `AnimatedSize` to create smooth expansion and collapse animations
- Places the content inside a Column when expanded
- Uses a BoxSignal mixin to signal expansion state changes
- The `Pylon` widget is used to provide the expansion state to child components

## Notes

- The header is always clickable, even when the Expander is expanded
- The content is completely removed from the widget tree when collapsed, not just hidden
- For complex control of multiple expanders, create a controller for each and manage them in your state
- You can customize the appearance of the expanded/collapsed state through the header widget
