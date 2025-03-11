# Image Components

The Image components provide a robust system for displaying images with loading states, placeholders, and error handling. The system includes utilities for displaying network images with blur hash or thumb hash placeholders for a smooth loading experience.

## Components

### ImageView

The main component for loading and displaying images with automatic placeholder and error handling.

#### Constructor

```dart
const ImageView({
  Key? key,
  required Future<String> url,
  Duration? fadeOutDuration = const Duration(milliseconds: 950),
  ImageStyle style = const ImageStyle(),
  String? thumbHash,
  String? blurHash,
  String? cacheKey,
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `url` | `Future<String>` | Future that resolves to the image URL to load |
| `fadeOutDuration` | `Duration?` | Duration for the fade animation when transitioning from placeholder to actual image |
| `style` | `ImageStyle` | Style configuration for the image |
| `thumbHash` | `String?` | Optional ThumbHash string for generating a placeholder |
| `blurHash` | `String?` | Optional BlurHash string for generating a placeholder |
| `cacheKey` | `String?` | Optional key for caching the image |

### ImagePlaceholderView

A component that displays a placeholder while the main image is loading, or an error indicator if the image failed to load.

#### Constructor

```dart
const ImagePlaceholderView({
  Key? key,
  bool isError = false,
  ImageStyle style = const ImageStyle(),
  String? blurHash,
  String? thumbHash,
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `isError` | `bool` | Whether to show an error state |
| `style` | `ImageStyle` | Style configuration for the placeholder |
| `blurHash` | `String?` | BlurHash string for generating a blurred placeholder |
| `thumbHash` | `String?` | ThumbHash string for generating a thumbnail placeholder |

### ImageWithStyle

A utility component that applies styling to an ImageProvider.

#### Constructor

```dart
const ImageWithStyle({
  Key? key,
  required ImageProvider image,
  ImageStyle style = const ImageStyle(),
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `image` | `ImageProvider` | The image provider to display |
| `style` | `ImageStyle` | Style configuration for the image |

### ImageStyle

A configuration class that defines how an image should be displayed.

#### Constructor

```dart
const ImageStyle({
  BoxFit fit = BoxFit.contain,
  double width = double.infinity,
  double height = double.infinity,
  Color? color,
  BlendMode? colorBlendMode,
  AlignmentGeometry? alignment,
});
```

#### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `fit` | `BoxFit` | How the image should be inscribed into the space |
| `width` | `double` | Width of the image |
| `height` | `double` | Height of the image |
| `color` | `Color?` | Color to blend with the image |
| `colorBlendMode` | `BlendMode?` | Blend mode for applying the color |
| `alignment` | `AlignmentGeometry?` | Alignment of the image within its bounds |

## Usage Examples

### Basic Image Loading

```dart
ImageView(
  url: Future.value("https://example.com/image.jpg"),
)
```

### Image with Placeholder

```dart
ImageView(
  url: getImageUrl(), // Future<String> that resolves to an image URL
  blurHash: "L6PZfSi_.AyE_3t7t7R**0o#DgR4",
  style: ImageStyle(
    fit: BoxFit.cover,
    width: 300,
    height: 200,
  ),
)
```

### Image with ThumbHash

```dart
ImageView(
  url: Future.value("https://example.com/image.jpg"),
  thumbHash: "2NeKDYiQlYn+d5K3iXyclJeAvweVlYiRSgeLlYeA2I",
  style: ImageStyle(
    fit: BoxFit.contain,
    alignment: Alignment.center,
  ),
)
```

### Styled Image with Color Overlay

```dart
ImageView(
  url: Future.value("https://example.com/icon.png"),
  style: ImageStyle(
    fit: BoxFit.contain,
    width: 48,
    height: 48,
    color: Colors.blue,
    colorBlendMode: BlendMode.srcIn,
  ),
)
```

### Handling Loading and Error States

```dart
FutureBuilder<String>(
  future: loadImageUrl(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text("Failed to load image URL");
    } else {
      return ImageView(
        url: Future.value(snapshot.data),
        blurHash: "L6PZfSi_.AyE_3t7t7R**0o#DgR4",
        style: ImageStyle(
          fit: BoxFit.cover,
        ),
      );
    }
  },
)
```

## Placeholder Technologies

The image components support two main placeholder technologies:

### BlurHash

BlurHash is a compact representation of a placeholder for an image. It provides a very small string that can be decoded into a blurred thumbnail of the original image. This is useful for showing a preview while the full image loads.

### ThumbHash

ThumbHash is similar to BlurHash but optimized for smaller sizes and better color reproduction. It also provides a compact string representation that can be decoded into a small placeholder image.

## Implementation Details

- The components use `CachedNetworkImage` internally for efficient network image loading and caching
- Placeholders are shown during loading and fade out when the actual image loads
- Error states show both the placeholder and an error icon
- The placeholder view animates between states for a smooth user experience
- The BoxSignal mixin allows for integration with the reactive framework

## Notes

- For best results, generate BlurHash or ThumbHash strings server-side and include them with your image metadata
- The `url` parameter is a Future, allowing for dynamic URL resolution
- You can use either BlurHash or ThumbHash, or neither (in which case a blank placeholder will be shown)
- Error states display a red warning icon over a faded placeholder
- The components integrate with Flutter's standard image loading and caching system
