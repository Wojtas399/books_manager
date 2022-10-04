class DateProvider {
  DateTime getNow() {
    return DateTime.now();
  }

  DateTime getDateOfFirstDayInPreviousMonth({
    required int month,
    required int year,
  }) {
    final DateTime dateOfFirstDayInCurrentMonth = DateTime(year, month);
    return DateTime(
      dateOfFirstDayInCurrentMonth.year,
      dateOfFirstDayInCurrentMonth.month - 1,
    );
  }

  DateTime getDateOfFirstDayInNextMonth({
    required int month,
    required int year,
  }) {
    final DateTime dateOfFirstDayInCurrentMonth = DateTime(year, month);
    return DateTime(
      dateOfFirstDayInCurrentMonth.year,
      dateOfFirstDayInCurrentMonth.month + 1,
    );
  }
}
