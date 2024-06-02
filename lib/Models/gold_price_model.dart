import 'dart:convert';

class GoldModel {
  double tenGram22K = 0.0;
  double tenGram24K = 0.0;
  int timeStamp = 0;
  GoldModel({
    required this.tenGram22K,
    required this.tenGram24K,
    required this.timeStamp,
  });

  GoldModel copyWith({
    double? tenGram22K,
    double? tenGram24K,
    int? timeStamp,
  }) {
    return GoldModel(
      tenGram22K: tenGram22K ?? this.tenGram22K,
      tenGram24K: tenGram24K ?? this.tenGram24K,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tenGram22K': tenGram22K,
      'tenGram24K': tenGram24K,
      'timeStamp': timeStamp,
    };
  }

  factory GoldModel.fromMap(Map<String, dynamic> map) {
    return GoldModel(
      tenGram22K: double.parse("${map['TenGram22K']}"),
      tenGram24K: double.parse("${map['TenGram24K']}"),
      timeStamp: map['timeStamp'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GoldModel.fromJson(String source) =>
      GoldModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'GoldModel(tenGram22K: $tenGram22K, tenGram24K: $tenGram24K, timeStamp: $timeStamp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GoldModel &&
        other.tenGram22K == tenGram22K &&
        other.tenGram24K == tenGram24K &&
        other.timeStamp == timeStamp;
  }

  @override
  int get hashCode =>
      tenGram22K.hashCode ^ tenGram24K.hashCode ^ timeStamp.hashCode;
}
