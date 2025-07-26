abstract class AiEdgeException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AiEdgeException(this.message, {this.code, this.details});

  @override
  String toString() => '$runtimeType: $message${code != null ? ' (Code: $code)' : ''}';
}

class InitializationException extends AiEdgeException {
  InitializationException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class GenerationException extends AiEdgeException {
  GenerationException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class StreamException extends AiEdgeException {
  StreamException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class UnsupportedDeviceException extends AiEdgeException {
  UnsupportedDeviceException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class AiCoreUnavailableException extends AiEdgeException {
  AiCoreUnavailableException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}

class InvalidArgumentException extends AiEdgeException {
  InvalidArgumentException(String message, {String? code, dynamic details})
      : super(message, code: code, details: details);
}