# CardCarousel

`CardCarousel` is a component that displays a horizontally scrollable list of widgets (typically cards) with attractive edge fading effects. It provides a convenient way to browse through a collection of cards in a limited horizontal space.

## Features

- **Horizontal Scrolling**: Allows users to scroll horizontally through content
- **Edge Fading Effect**: Applies a gradient fade at the edges to indicate more content
- **Bouncing Physics**: Uses bouncing scroll physics for a natural feel
- **Customizable Sharpness**: Control the intensity of the edge fading effect

## Constructor

```dart
const CardCarousel({
  Key? key,
  List<Widget> children = const [],
  int? sharpness,
});
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `children` | `List<Widget>` | The list of widgets to display in the carousel |
| `sharpness` | `int?` | Controls the intensity of the edge gradient fade effect (higher values create sharper gradients) |

## CardCarouselTheme

The appearance of `CardCarousel` can be customized using the `CardCarouselTheme` class, which can be set in the `ArcaneTheme`.

### Constructor

```dart
const CardCarouselTheme({
  int sharpness = 9,
});
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `sharpness` | `int` | Default sharpness value for the edge gradient fade effect |

## Usage Examples

### Basic Card Carousel

```dart
CardCarousel(
  children: [
    BasicCard(
      title: Text("Card 1"),
      content: Text("First card content"),
    ),
    BasicCard(
      title: Text("Card 2"),
      content: Text("Second card content"),
    ),
    BasicCard(
      title: Text("Card 3"),
      content: Text("Third card content"),
    ),
  ],
)
```

### Customized Card Carousel

```dart
CardCarousel(
  sharpness: 12, // Higher value for sharper edge fading
  children: [
    SizedBox(
      width: 200,
      child: BasicCard(
        title: Text("Product"),
        content: Column(
          children: [
            Image.network("https://example.com/product.jpg"),
            Text("Product description"),
            Text("\$29.99", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
    SizedBox(
      width: 200,
      child: BasicCard(
        title: Text("Another Product"),
        content: Column(
          children: [
            Image.network("https://example.com/product2.jpg"),
            Text("Another product description"),
            Text("\$39.99", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
    // More products...
  ],
)
```

### Customizing with Theme

To customize the default sharpness of all carousels in your app:

```dart
ArcaneTheme(
  cardCarousel: CardCarouselTheme(
    sharpness: 6, // Lower value for softer edge fading
  ),
  // Other theme properties...
)
```

## Implementation Details

- The carousel uses a `SingleChildScrollView` with horizontal scrolling
- The edge fading effect is implemented using a `LinearGradient` that shows the background color at the edges
- The gradient opacity adapts to the scroll position to maintain a consistent look
- The edge gradient is applied only when there is content to scroll to in that direction

## Notes

- For best results, make sure the carousel has enough items to allow scrolling
- The width of each child will determine how many items are visible at once
- You can wrap each child in a `SizedBox` with a fixed width to control item sizing
- The edge fading effect works best when the background color contrasts with the cards
