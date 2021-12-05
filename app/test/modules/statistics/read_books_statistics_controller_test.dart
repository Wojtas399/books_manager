import 'package:app/core/day/day_query.dart';
import 'package:app/core/services/date_service.dart';
import 'package:app/modules/statistics/elements/read_books_statistics/read_books_statistics_controller.dart';
import 'package:app/modules/statistics/elements/report_type_dropdown_form_field.dart';
import 'package:app/widgets/charts/line_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import '../global_mocks.dart';

void main() {
  DateTime currentDate = new DateTime.now();
  DayQuery dayQuery = MockDayQuery();
  late ReadBooksStatisticsController controller;

  setUp(() {
    controller = ReadBooksStatisticsController(dayQuery: dayQuery);
  });

  tearDown(() => reset(dayQuery));

  group('weekly report type (default)', () {
    List<String> currentWeekDays = DateService.getWeekDays(currentDate);

    setUp(() {
      for (String day in currentWeekDays) {
        when(() => dayQuery.selectBooksIds(day))
            .thenAnswer((_) => new BehaviorSubject<List<String>>.seeded(
                  ['b1', 'b2', 'b3'],
                ));
      }
    });

    group('chart title date', () {
      test('should be the date range of the current week', () async {
        String chartTitleDate = await controller.chartTitleDate$.first;
        expect(
          chartTitleDate,
          '${currentWeekDays[0]} - ${currentWeekDays[currentWeekDays.length - 1]}',
        );
      });
    });

    group('chart data', () {
      test('should contain the chart data of the current week', () async {
        List<LineChartData> chartData = await controller.chartData$.first;
        expect(chartData[0].xValue, 'Pon');
        expect(chartData[0].yValue, 3);
        expect(chartData[3].xValue, 'Czw');
        expect(chartData[3].yValue, 3);
        expect(chartData[6].xValue, 'Nie');
        expect(chartData[6].yValue, 3);
      });
    });
  });

  group('monthly report type', () {
    List<String> currentMonthDays = DateService.getMonthDays(currentDate);

    setUp(() {
      controller.onChangeReportType(ReportType.monthly);
      for (String day in currentMonthDays) {
        when(() => dayQuery.selectBooksIds(day))
            .thenAnswer((_) => new BehaviorSubject<List<String>>.seeded(
                  ['b1', 'b2'],
                ));
      }
    });

    group('chart title date', () {
      test('should be the month name and the year number', () async {
        String chartTitleDate = await controller.chartTitleDate$.first;
        expect(
          chartTitleDate,
          '${DateService.getMonthName(currentDate.month - 1)} ${currentDate.year}',
        );
      });
    });

    group('chart data', () {
      test('should contain the chart data of the current month', () async {
        List<LineChartData> chartData = await controller.chartData$.first;
        expect(chartData[0].xValue, currentMonthDays[0]);
        expect(chartData[0].yValue, 2);
        expect(chartData[15].xValue, currentMonthDays[15]);
        expect(chartData[3].yValue, 2);
      });
    });
  });

  group('annual report type', () {
    List<String> currentYearDays = DateService.getYearDays(currentDate);

    setUp(() {
      controller.onChangeReportType(ReportType.annual);
      for (String day in currentYearDays) {
        when(() => dayQuery.selectBooksIds(day))
            .thenAnswer((_) => new BehaviorSubject<List<String>>.seeded(
                  ['b1', 'b2', 'b3', 'b4'],
                ));
      }
    });

    group('chart title date', () {
      test('should be the year number', () async {
        String chartTitleDate = await controller.chartTitleDate$.first;
        expect(
          chartTitleDate,
          '${currentDate.year}',
        );
      });
    });

    group('chart data', () {
      test('should contain the chart data of the current year', () async {
        List<LineChartData> chartData = await controller.chartData$.first;
        expect(chartData[0].xValue, DateService.getMonthShortcut(0));
        expect(chartData[0].yValue, 4);
        expect(chartData[11].xValue, DateService.getMonthShortcut(11));
        expect(chartData[11].yValue, 4);
      });
    });
  });

  group('on change date back', () {
    group('weekly report type', () {
      setUp(() {
        controller.onChangeDateBack();
      });

      test('should move to the previous week', () async {
        DateTime newDate = new DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day - 7,
        );
        List<String> newWeekDays = DateService.getWeekDays(newDate);
        String chartTitleDate = await controller.chartTitleDate$.first;
        expect(chartTitleDate, '${newWeekDays[0]} - ${newWeekDays[6]}');
      });
    });

    group('monthly report type', () {
      setUp(() {
        controller.onChangeReportType(ReportType.monthly);
        controller.onChangeDateBack();
      });

      test('should move to the previous month', () async {
        DateTime newDate = new DateTime(
          currentDate.year,
          currentDate.month - 1,
          currentDate.day,
        );
        String chartTitleDate = await controller.chartTitleDate$.first;
        expect(
          chartTitleDate,
          '${DateService.getMonthName(newDate.month - 1)} ${newDate.year}',
        );
      });
    });

    group('annual report type', () {
      setUp(() {
        controller.onChangeReportType(ReportType.annual);
        controller.onChangeDateBack();
      });

      test('should move to the previous year', () async {
        DateTime newDate = new DateTime(
          currentDate.year - 1,
          currentDate.month,
          currentDate.day,
        );
        String chartTitleDate = await controller.chartTitleDate$.first;
        expect(chartTitleDate, '${newDate.year}');
      });
    });
  });

  group('on change date forward', () {
    group('weekly report type', () {
      setUp(() {
        controller.onChangeDateForward();
      });

      test('should move to the next week', () async {
        DateTime newDate = new DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day + 7,
        );
        List<String> newWeekDays = DateService.getWeekDays(newDate);
        String chartTitleDate = await controller.chartTitleDate$.first;
        expect(chartTitleDate, '${newWeekDays[0]} - ${newWeekDays[6]}');
      });
    });

    group('monthly report type', () {
      setUp(() {
        controller.onChangeReportType(ReportType.monthly);
        controller.onChangeDateForward();
      });

      test('should move to the next month', () async {
        DateTime newDate = new DateTime(
          currentDate.year,
          currentDate.month + 1,
          currentDate.day,
        );
        String chartTitleDate = await controller.chartTitleDate$.first;
        expect(
          chartTitleDate,
          '${DateService.getMonthName(newDate.month - 1)} ${newDate.year}',
        );
      });
    });

    group('annual report type', () {
      setUp(() {
        controller.onChangeReportType(ReportType.annual);
        controller.onChangeDateForward();
      });

      test('should move to the next year', () async {
        DateTime newDate = new DateTime(
          currentDate.year + 1,
          currentDate.month,
          currentDate.day,
        );
        String chartTitleDate = await controller.chartTitleDate$.first;
        expect(chartTitleDate, '${newDate.year}');
      });
    });
  });
}
