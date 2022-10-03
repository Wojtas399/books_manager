import 'package:app/providers/date_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DateProvider dateProvider;

  setUp(() {
    dateProvider = DateProvider();
  });

  test(
    'get date of first day in previous month',
    () {
      final DateTime date = DateTime(2022, 9, 20);
      final DateTime expectedDate = DateTime(2022, 8, 1);

      final DateTime dateOfFirstDayInPreviousMonth =
          dateProvider.getDateOfFirstDayInPreviousMonth(
        month: date.month,
        year: date.year,
      );

      expect(dateOfFirstDayInPreviousMonth, expectedDate);
    },
  );

  test(
    'get date of first day in next month',
    () {
      final DateTime date = DateTime(2022, 5, 3);
      final DateTime expectedDate = DateTime(2022, 6, 1);

      final DateTime dateOfFirstDayInNextMonth =
          dateProvider.getDateOfFirstDayInNextMonth(
        month: date.month,
        year: date.year,
      );

      expect(dateOfFirstDayInNextMonth, expectedDate);
    },
  );
}
