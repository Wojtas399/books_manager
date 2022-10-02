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

  static int getDaysInMonth({
    required int month,
    required int year,
  }) {
    return DateTime(year, month + 1, 0).day;
  }
}
