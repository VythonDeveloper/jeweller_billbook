import 'dart:convert';

class SilverModel {
  int timeStamp = 0;
  double hundredGm = 0.0;
  double tenGm = 0.0;
  SilverModel({
    required this.timeStamp,
    required this.hundredGm,
    required this.tenGm,
  });

  SilverModel copyWith({
    int? timeStamp,
    double? hundredGm,
    double? tenGm,
  }) {
    return SilverModel(
      timeStamp: timeStamp ?? this.timeStamp,
      hundredGm: hundredGm ?? this.hundredGm,
      tenGm: tenGm ?? this.tenGm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timeStamp': timeStamp,
      'hundredGm': hundredGm,
      'tenGm': tenGm,
    };
  }

  factory SilverModel.fromMap(Map<String, dynamic> map) {
    return SilverModel(
      timeStamp: map['timeStamp'] ?? 0,
      hundredGm: double.parse(map['HundredGm']),
      tenGm: double.parse(map['TenGm']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SilverModel.fromJson(String source) =>
      SilverModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'SilverModel(timeStamp: $timeStamp, hundredGm: $hundredGm, tenGm: $tenGm)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SilverModel &&
        other.timeStamp == timeStamp &&
        other.hundredGm == hundredGm &&
        other.tenGm == tenGm;
  }

  @override
  int get hashCode => timeStamp.hashCode ^ hundredGm.hashCode ^ tenGm.hashCode;
}
