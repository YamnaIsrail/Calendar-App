class MedicineReminder {
  final String title;
  final String time;
  final String date;

  MedicineReminder({required this.title, required this.time, required this.date});

  // Convert a MedicineReminder into a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time,
      'date': date,
    };
  }

  // Convert a Map into a MedicineReminder
  factory MedicineReminder.fromMap(Map<String, dynamic> map) {
    return MedicineReminder(
      title: map['title'],
      time: map['time'],
      date: map['date'],
    );
  }
}
