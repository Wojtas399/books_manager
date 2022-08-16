import 'package:app/constants/date_constants.dart';
import 'package:intl/intl.dart';

class DateService {
  static String getCurrentDate() {
    return new DateFormat('dd.MM.yyyy').format(new DateTime.now());
  }

  static int compareDatesDescending(String date1, String date2) {
    List<String> date1InArray = date1.split('.');
    List<String> date2InArray = date2.split('.');
    int date1Year = int.parse(date1InArray[2]);
    int date2Year = int.parse(date2InArray[2]);
    if (date1Year > date2Year) {
      return -1;
    } else if (date1Year < date2Year) {
      return 1;
    } else {
      int date1Month = int.parse(date1InArray[1]);
      int date2Month = int.parse(date2InArray[1]);
      if (date1Month > date2Month) {
        return -1;
      } else if (date1Month < date2Month) {
        return 1;
      } else {
        int date1Day = int.parse(date1InArray[0]);
        int date2Day = int.parse(date2InArray[0]);
        if (date1Day > date2Day) {
          return -1;
        } else if (date1Day < date2Day) {
          return 1;
        } else {
          return 0;
        }
      }
    }
  }

  static int daysBetween(String dateFrom, String dateTo) {
    List<String> dateFromInArray = dateFrom.split('.');
    List<String> dateToInArray = dateTo.split('.');
    DateTime from = DateTime(
      int.parse(dateFromInArray[2]),
      int.parse(dateFromInArray[1]),
      int.parse(dateFromInArray[0]),
    );
    DateTime to = DateTime(
      int.parse(dateToInArray[2]),
      int.parse(dateToInArray[1]),
      int.parse(dateToInArray[0]),
    );
    return (to.difference(from).inHours / 24).round();
  }

  static String getDayShortcut(int number) {
    return DateConstants.DAYS_SHORTNAMES[number];
  }

  static String getMonthShortcut(int number) {
    return DateConstants.MONTH_SHORTNAMES[number];
  }

  static String getMonthName(int number) {
    return DateConstants.MONTH_NAMES[number];
  }

  static List<String> getWeekDays(DateTime date) {
    DateTime startFrom = date.subtract(Duration(days: date.weekday));
    List<String> datesList = List.generate(
      7,
      (i) => '${startFrom.add(Duration(days: i + 1))}',
    );
    return datesList
        .map((date) => date.split(' ')[0].split('-').reversed.join('.'))
        .toList();
  }

  static List<String> getMonthDays(DateTime date) {
    DateTime lastDayOfMonth = new DateTime(date.year, date.month + 1, 0);
    return _generateDatesFromMonth(lastDayOfMonth);
  }

  static List<String> getYearDays(DateTime date) {
    List<String> dates = [];
    for (int i = 1; i <= 12; i++) {
      DateTime lastDayOfMonth = new DateTime(date.year, i, 0);
      List<String> datesFromMonth = _generateDatesFromMonth(lastDayOfMonth);
      for (String date in datesFromMonth) {
        dates.add(date);
      }
    }
    return dates;
  }

  static List<String> _generateDatesFromMonth(DateTime lastDayOfMonth) {
    return List.generate(
      lastDayOfMonth.day,
      (i) =>
          '${_getDateNumberAsString(i + 1)}.${_getDateNumberAsString(lastDayOfMonth.month)}.${lastDayOfMonth.year}',
    );
  }

  static String _getDateNumberAsString(int number) {
    return number < 10 ? '0$number' : '$number';
  }
}
