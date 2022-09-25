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
}
