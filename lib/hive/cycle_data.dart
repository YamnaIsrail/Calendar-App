class CycleData {
  final String cycleStartDate;
  final int cycleLength;

  CycleData({required this.cycleStartDate, required this.cycleLength});

  Map<String, dynamic> toMap() {
    return {
      'cycleStartDate': cycleStartDate,
      'cycleLength': cycleLength,
    };
  }

  factory CycleData.fromMap(Map<String, dynamic> map) {
    return CycleData(
      cycleStartDate: map['cycleStartDate'],
      cycleLength: map['cycleLength'],
    );
  }
}
