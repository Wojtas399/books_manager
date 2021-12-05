import 'package:app/core/day/day_query.dart';
import 'package:app/core/services/date_service.dart';
import 'package:app/modules/statistics/elements/read_pages_statistics/read_pages_statistics_controller.dart';
import 'package:app/modules/statistics/elements/report_type_dropdown_form_field.dart';
import 'package:app/widgets/charts/line_chart.dart';
import 'package:rxdart/rxdart.dart';

class ReadBooksStatisticsController {
  late final DayQuery _dayQuery;
  BehaviorSubject<ReportType> _reportType =
      new BehaviorSubject<ReportType>.seeded(ReportType.weekly);
  BehaviorSubject<DateTime> _date =
      new BehaviorSubject<DateTime>.seeded(new DateTime.now());

  ReadBooksStatisticsController({required DayQuery dayQuery}) {
    _dayQuery = dayQuery;
  }

  Stream<ReportType> get _reportType$ => _reportType.stream;

  Stream<DateTime> get _date$ => _date.stream;

  Stream<List<String>> get _days$ => Rx.combineLatest2(_reportType$, _date$,
      (ReportType reportType, DateTime date) => _getDays(reportType, date));

  Stream<List<List<String>>> get _booksIds$ => _days$
      .map((days) => days.map((day) => _dayQuery.selectBooksIds(day)))
      .flatMap((streams) => Rx.combineLatest(streams, (values) {
            return values as List<List<String>>;
          }));

  Stream<List<int>> get _booksAmount$ => Rx.combineLatest3(
        _reportType$,
        _days$,
        _booksIds$,
        (
          ReportType reportType,
          List<String> days,
          List<List<String>> booksIds,
        ) {
          if (reportType == ReportType.annual) {
            return List.generate(12, (i) {
              List<String> books = [];
              for (int j = 0; j < days.length; j++) {
                if (int.parse(days[j].split('.')[1]) == i + 1) {
                  for (String bookId in booksIds[j]) {
                    if (!books.contains(bookId)) {
                      books.add(bookId);
                    }
                  }
                }
              }
              return books.length;
            });
          } else {
            return booksIds.map((ids) => ids.length).toList();
          }
        },
      );

  Stream<String> get chartTitleDate$ => Rx.combineLatest3(
        _reportType$,
        _days$,
        _date$,
        (ReportType reportType, List<String> days, DateTime date) =>
            _generateChartTitleDate(reportType, days, date),
      );

  Stream<List<LineChartData>> get chartData$ => Rx.combineLatest3(
        _reportType$,
        _days$,
        _booksAmount$,
        (ReportType reportType, List<String> days, List<int> booksAmount) =>
            _generateChartData(reportType, days, booksAmount),
      );

  onChangeReportType(ReportType reportType) {
    _reportType.add(reportType);
    _date.add(DateTime.now());
  }

  onChangeDateBack() {
    _changeDate(DateChangeDirection.back);
  }

  onChangeDateForward() {
    _changeDate(DateChangeDirection.forward);
  }

  List<String> _getDays(ReportType reportType, DateTime date) {
    switch (reportType) {
      case ReportType.weekly:
        return DateService.getWeekDays(date);
      case ReportType.monthly:
        return DateService.getMonthDays(date);
      case ReportType.annual:
        return DateService.getYearDays(date);
    }
  }

  List<LineChartData> _generateChartData(
    ReportType reportType,
    List<String> days,
    List<int> booksAmount,
  ) {
    switch (reportType) {
      case ReportType.weekly:
        return List.generate(
          booksAmount.length,
          (i) => LineChartData(
            xValue: DateService.getDayShortcut(i),
            yValue: booksAmount[i],
          ),
        );
      case ReportType.monthly:
        return List.generate(
          booksAmount.length,
          (i) => LineChartData(xValue: days[i], yValue: booksAmount[i]),
        );
      case ReportType.annual:
        return List.generate(
          12,
          (i) => LineChartData(
            xValue: DateService.getMonthShortcut(i),
            yValue: booksAmount[i],
          ),
        );
    }
  }

  String _generateChartTitleDate(
    ReportType reportType,
    List<String> days,
    DateTime date,
  ) {
    switch (reportType) {
      case ReportType.weekly:
        return '${days[0]} - ${days[days.length - 1]}';
      case ReportType.monthly:
        return '${DateService.getMonthName(date.month - 1)} ${date.year}';
      case ReportType.annual:
        return '${date.year}';
    }
  }

  _changeDate(DateChangeDirection direction) {
    DateTime currentDate = _date.value;
    switch (_reportType.value) {
      case ReportType.weekly:
        _date.add(new DateTime(
          currentDate.year,
          currentDate.month,
          direction == DateChangeDirection.back
              ? currentDate.day - 7
              : currentDate.day + 7,
        ));
        break;
      case ReportType.monthly:
        _date.add(new DateTime(
          currentDate.year,
          direction == DateChangeDirection.back
              ? currentDate.month - 1
              : currentDate.month + 1,
          currentDate.day,
        ));
        break;
      case ReportType.annual:
        _date.add(new DateTime(
          direction == DateChangeDirection.back
              ? currentDate.year - 1
              : currentDate.year + 1,
          currentDate.month,
          currentDate.day,
        ));
        break;
    }
  }
}
