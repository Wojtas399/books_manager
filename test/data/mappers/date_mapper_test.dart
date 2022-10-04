import 'package:app/data/mappers/date_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final DateTime dateTime = DateTime(2022, 5, 20);
  const String dateStr = '20-05-2022';

  test(
    'map from date time to string',
    () {
      final String mappedDateStr = DateMapper.mapFromDateTimeToString(dateTime);

      expect(mappedDateStr, dateStr);
    },
  );

  test(
    'map from string to date time',
    () {
      final DateTime mappedDateTime = DateMapper.mapFromStringToDateTime(
        dateStr,
      );

      expect(mappedDateTime, dateTime);
    },
  );
}
