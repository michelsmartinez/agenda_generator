import 'package:intl/intl.dart';

class CalendarGenerator {
  static List<DateTime> getDaysInMonth(int year, int month) {
    final days = <DateTime>[];
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0); // Last day of current month

    for (var i = 0; i <= lastDayOfMonth.day - 1; i++) {
      days.add(firstDayOfMonth.add(Duration(days: i)));
    }
    return days;
  }

  static String getMonthName(int month) {
    return DateFormat.MMMM().format(DateTime(2000, month));
  }

  // Simplified for now, can be expanded for full calendar grid layout
  static List<List<int?>> getMonthCalendarLayout(int year, int month) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = getDaysInMonth(year, month).length;
    final firstWeekday = firstDayOfMonth.weekday; // Monday is 1, Sunday is 7

    final weeks = <List<int?>>[];
    var currentWeek = <int?>[];

    // Add nulls for leading empty days
    for (var i = 0; i < firstWeekday - 1; i++) {
      currentWeek.add(null);
    }

    for (var day = 1; day <= daysInMonth; day++) {
      currentWeek.add(day);
      if (currentWeek.length == 7) {
        weeks.add(currentWeek.toList());
        currentWeek = <int?>[];
      }
    }

    // Add nulls for trailing empty days
    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add(null);
      }
      weeks.add(currentWeek.toList());
    }

    return weeks;
  }
}
