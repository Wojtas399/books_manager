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
}
