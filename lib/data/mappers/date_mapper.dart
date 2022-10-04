import 'package:app/utils/utils.dart';

class DateMapper {
  static String mapFromDateTimeToString(DateTime dateTime) {
    final int day = dateTime.day;
    final int month = dateTime.month;
    final int year = dateTime.year;
    return '${Utils.twoDigits(day)}-${Utils.twoDigits(month)}-$year';
  }

  static DateTime mapFromStringToDateTime(String dateStr) {
    final List<String> dateParts = dateStr.split('-');
    final int day = int.parse(dateParts.first);
    final int month = int.parse(dateParts[1]);
    final int year = int.parse(dateParts.last);
    return DateTime(year, month, day);
  }
}
