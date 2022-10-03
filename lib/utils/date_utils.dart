class DateUtils {
  static bool isDate1LaterThanDate2({
    required DateTime date1,
    required DateTime date2,
  }) {
    if (date1.compareTo(date2) == 1) {
      return true;
    }
    return false;
  }

  static bool isDateFromMonthAndYear({
    required DateTime date,
    required int month,
    required int year,
  }) {
    return date.month == month && date.year == year;
  }

  static bool areDatesTheSame({
    required DateTime date1,
    required DateTime date2,
  }) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}
