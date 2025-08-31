/// Result of a generation request.
class GenerationResult {
  final String content;
  final String? finishReason;
  final bool success;
  final List<String>? chunks;

  GenerationResult({
    required this.content,
    this.finishReason,
    required this.success,
    this.chunks,
  });

  factory GenerationResult.fromMap(Map<String, dynamic> map) {
    return GenerationResult(
      content: map['content'] ?? '',
      finishReason: map['finishReason'],
      success: map['success'] ?? false,
      chunks: map['chunks'] != null ? List<String>.from(map['chunks']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'finishReason': finishReason,
      'success': success,
      'chunks': chunks,
    };
  }

  @override
  String toString() {
    return 'GenerationResult(content: $content, finishReason: $finishReason, success: $success)';
  }
}
