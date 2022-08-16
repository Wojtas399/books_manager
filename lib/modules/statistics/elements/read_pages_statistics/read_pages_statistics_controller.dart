import 'package:app/core/day/day_query.dart';
import 'package:app/core/services/date_service.dart';
import 'package:app/modules/statistics/elements/report_type_dropdown_form_field.dart';
import 'package:app/widgets/charts/line_chart.dart';
import 'package:rxdart/rxdart.dart';

class ReadPagesStatisticsController {
  late final DayQuery _dayQuery;
  BehaviorSubject<ReportType> _reportType =
      new BehaviorSubject<ReportType>.seeded(ReportType.weekly);
  BehaviorSubject<DateTime> _date =
      new BehaviorSubject<DateTime>.seeded(DateTime.now());

  ReadPagesStatisticsController({required DayQuery dayQuery}) {
    _dayQuery = dayQuery;
  }

  Stream<ReportType> get _reportType$ => _reportType.stream;

  Stream<DateTime> get _date$ => _date.stream;

  Stream<List<String>> get _days$ => Rx.combineLatest2(_reportType$, _date$,
      (ReportType reportType, DateTime date) => _getDays(reportType, date));

  Stream<List<int>> get _pages$ => _days$
      .map((days) => days
          .map((day) => _dayQuery.selectTheAmountOfReadPagesFromTheDay(day)))
      .flatMap((streams) =>
          Rx.combineLatest(streams, (values) => values as List<int>));

  Stream<List<LineChartData>> get chartData$ => Rx.combineLatest3(
        _reportType$,
        _days$,
        _pages$,
        (ReportType reportType, List<String> days, List<int> pages) =>
            _generateChartData(reportType, days, pages),
      );

  Stream<String> get chartTitleDate$ => Rx.combineLatest3(
        _reportType$,
        _days$,
        _date$,
        (ReportType reportType, List<String> days, DateTime date) =>
            _generateChartTitleDate(reportType, days, date),
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
    List<int> pages,
  ) {
    switch (reportType) {
      case ReportType.weekly:
        return List.generate(
          pages.length,
          (i) => LineChartData(
            xValue: DateService.getDayShortcut(i),
            yValue: pages[i],
          ),
        );
      case ReportType.monthly:
        return List.generate(
          pages.length,
          (i) => LineChartData(xValue: days[i], yValue: pages[i]),
        );
      case ReportType.annual:
        return List.generate(
          12,
          (i) {
            int pagesAmount = 0;
            for (int j = 0; j < days.length; j++) {
              if (int.parse(days[j].split('.')[1]) == i + 1) {
                pagesAmount += pages[j];
              }
            }
            return LineChartData(
              xValue: DateService.getMonthShortcut(i),
              yValue: pagesAmount,
            );
          },
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

enum DateChangeDirection { back, forward }
