import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A wrapper [ImageProvider] that resolves a [Future] to get the actual data
/// (e.g. a URL string) needed to build the delegate [ImageProvider].
@immutable
class FutureImageProvider<T, X extends Object> extends ImageProvider<X> {
  /// The future that must resolve before the image can be loaded.
  final Future<T> future;

  /// A builder that creates the actual ImageProvider once the future resolves.
  final ImageProvider Function(T result) providerBuilder;

  const FutureImageProvider({
    required this.future,
    required this.providerBuilder,
  });

  @override
  Future<X> obtainKey(ImageConfiguration configuration) async {
    final result = await future;
    final provider = providerBuilder(result);
    return provider.obtainKey(configuration).then((key) => key as X);
  }

  @override
  ImageStreamCompleter loadImage(Object key, ImageDecoderCallback decode) {
    final completer = _ProxyImageStreamCompleter();
    _resolveAndLoad(key, decode, completer);
    return completer;
  }

  Future<void> _resolveAndLoad(
    Object key,
    ImageDecoderCallback decode,
    _ProxyImageStreamCompleter completer,
  ) async {
    try {
      final result = await future;
      final provider = providerBuilder(result);

      // Load the image from the delegate provider
      final delegateCompleter = provider.loadImage(key, decode);

      // Forward all events from the delegate to our proxy completer
      delegateCompleter.addListener(
        ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
            completer.setImage(image);
          },
          onChunk: (ImageChunkEvent event) {
            completer.reportChunk(event);
          },
          onError: (Object exception, StackTrace? stackTrace) {
            completer.setError(exception, stackTrace);
          },
        ),
      );
    } catch (exception, stackTrace) {
      completer.setError(exception, stackTrace);
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is FutureImageProvider<T, X> &&
        other.future == future &&
        other.providerBuilder == providerBuilder;
  }

  @override
  int get hashCode => Object.hash(future, providerBuilder);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'FutureImageProvider')}(future: $future)';
}

/// A private helper class to bridge the gap between the Future resolution
/// and the actual ImageStreamCompleter logic.
class _ProxyImageStreamCompleter extends ImageStreamCompleter {
  @override
  void setImage(ImageInfo image) {
    super.setImage(image);
  }

  void setError(Object exception, StackTrace? stackTrace) {
    reportError(
      context: ErrorDescription('Error loading image in FutureImageProvider'),
      exception: exception,
      stack: stackTrace,
    );
  }

  void reportChunk(ImageChunkEvent event) {
    reportImageChunkEvent(event);
  }
}
