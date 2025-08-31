class InferenceConfig {
  final double temperature;
  final int topK;
  final double topP;
  final int maxOutputTokens;

  InferenceConfig({
    this.temperature = 0.8,
    this.topK = 40,
    this.topP = 0.95,
    this.maxOutputTokens = 1024,
  });

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'topK': topK,
      'topP': topP,
      'maxOutputTokens': maxOutputTokens,
    };
  }

  @override
  String toString() {
    return 'InferenceConfig(temperature: $temperature, topK: $topK, topP: $topP, maxOutputTokens: $maxOutputTokens)';
  }
}
