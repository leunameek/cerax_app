class RangeInfo {
  final double min;
  final double max;
  final Map<String, String> advice;

  RangeInfo({required this.min, required this.max, required this.advice});

  factory RangeInfo.fromJson(Map<String, dynamic> json) {
    return RangeInfo(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      advice: Map<String, String>.from(json['advice']),
    );
  }

  String evaluate(double value) {
    if (value < min) return advice['low']!;
    if (value > max) return advice['high']!;
    return advice['ok']!;
  }
}
