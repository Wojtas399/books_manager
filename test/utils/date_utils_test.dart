import 'package:app/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'is date1 later than date2, should be true if date1 is from the time after date2',
    () {
      final DateTime date1 = DateTime(2022, 9, 23);
      final DateTime date2 = DateTime(2022, 9, 20);

      final bool result = DateUtils.isDate1LaterThanDate2(
        date1: date1,
        date2: date2,
      );

      expect(result, true);
    },
  );

  test(
    'is date1 later than date2, should be false if date1 is from the time before date2',
    () {
      final DateTime date1 = DateTime(2022, 9, 20);
      final DateTime date2 = DateTime(2022, 9, 23);

      final bool result = DateUtils.isDate1LaterThanDate2(
        date1: date1,
        date2: date2,
      );

      expect(result, false);
    },
  );

  test(
    'is date1 later than date2, should be false if date1 the same as date2',
    () {
      final DateTime date1 = DateTime(2022, 9, 23);
      final DateTime date2 = DateTime(2022, 9, 23);

      final bool result = DateUtils.isDate1LaterThanDate2(
        date1: date1,
        date2: date2,
      );

      expect(result, false);
    },
  );

  test(
    'is date from month and year, should return true if date is from given month and year',
    () {
      final DateTime date = DateTime(2022, 1, 20);
      const int month = 1;
      const int year = 2022;

      final bool result = DateUtils.isDateFromMonthAndYear(
        date: date,
        month: month,
        year: year,
      );

      expect(result, true);
    },
  );

  test(
    'is date from month and year, should return false if date is from given month and but not from given year',
    () {
      final DateTime date = DateTime(2022, 1, 20);
      const int month = 1;
      const int year = 2021;

      final bool result = DateUtils.isDateFromMonthAndYear(
        date: date,
        month: month,
        year: year,
      );

      expect(result, false);
    },
  );

  test(
    'is date from month and year, should return false if date is from given year and but not from given month',
    () {
      final DateTime date = DateTime(2022, 1, 20);
      const int month = 4;
      const int year = 2022;

      final bool result = DateUtils.isDateFromMonthAndYear(
        date: date,
        month: month,
        year: year,
      );

      expect(result, false);
    },
  );

  test(
    'are dates the same, day, month and year are the same in both dates, should return true',
    () {
      final DateTime date1 = DateTime(2022, 9, 20);
      final DateTime date2 = DateTime(2022, 9, 20);

      final bool result = DateUtils.areDatesTheSame(
        date1: date1,
        date2: date2,
      );

      expect(result, true);
    },
  );

  test(
    'are dates the same, days are different, should return false',
    () {
      final DateTime date1 = DateTime(2022, 9, 22);
      final DateTime date2 = DateTime(2022, 9, 20);

      final bool result = DateUtils.areDatesTheSame(
        date1: date1,
        date2: date2,
      );

      expect(result, false);
    },
  );

  test(
    'are dates the same, months are different, should return false',
    () {
      final DateTime date1 = DateTime(2022, 9, 20);
      final DateTime date2 = DateTime(2022, 5, 20);

      final bool result = DateUtils.areDatesTheSame(
        date1: date1,
        date2: date2,
      );

      expect(result, false);
    },
  );

  test(
    'are dates the same, years are different, should return false',
    () {
      final DateTime date1 = DateTime(2022, 9, 20);
      final DateTime date2 = DateTime(2020, 9, 20);

      final bool result = DateUtils.areDatesTheSame(
        date1: date1,
        date2: date2,
      );

      expect(result, false);
    },
  );
}
