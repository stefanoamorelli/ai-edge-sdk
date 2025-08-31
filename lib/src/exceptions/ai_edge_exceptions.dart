/// Base class for AI Edge SDK exceptions.
abstract class AiEdgeException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AiEdgeException(this.message, {this.code, this.details});

  @override
  String toString() => '$runtimeType: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Thrown when the SDK is not initialized or fails to initialize.
class InitializationException extends AiEdgeException {
  InitializationException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// Thrown when a non-streaming content generation request fails.
class GenerationException extends AiEdgeException {
  GenerationException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// Thrown when a streaming generation request fails.
class StreamException extends AiEdgeException {
  StreamException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// Thrown when the current device is not supported.
class UnsupportedDeviceException extends AiEdgeException {
  UnsupportedDeviceException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// Thrown when AICore is not available on the device.
class AiCoreUnavailableException extends AiEdgeException {
  AiCoreUnavailableException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

/// Thrown when invalid arguments are passed to plugin methods.
class InvalidArgumentException extends AiEdgeException {
  InvalidArgumentException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}
