
class CycleStatusHelper {
  static String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  static int getDaysUntilNextPeriod(DateTime lastPeriodStart, int periodLength) {
    final nextPeriodStart = lastPeriodStart.add(Duration(days: periodLength));
    final today = DateTime.now();
    return nextPeriodStart.difference(today).inDays;
  }

  static DateTime getNextPeriodDate(DateTime lastPeriodStart, int periodLength) {
    return lastPeriodStart.add(Duration(days: periodLength));
  }

  static String getPhaseStartDate(DateTime lastPeriodStart, int phaseOffset, int periodLength) {
    final phaseStartDate = lastPeriodStart.add(Duration(days: phaseOffset));
    return formatDate(phaseStartDate);
  }

  static int getCurrentCycleDay(DateTime lastPeriodStart) {
    final today = DateTime.now();
    return today.difference(lastPeriodStart).inDays + 1;
  }
}
