import 'package:app/core/book/book_query.dart';
import 'package:app/core/day/day_query.dart';
import 'package:app/modules/calendar/elements/day_info/day_info_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../global_mocks.dart';

void main() {
  const String dayId = '05.12.2021';
  late DayQuery dayQuery;
  late BookQuery bookQuery;
  late DayInfoController controller;

  setUp(() {
    dayQuery = MockDayQuery();
    bookQuery = MockBookQuery();
    controller = new DayInfoController(
      dayId: dayId,
      dayQuery: dayQuery,
      bookQuery: bookQuery,
    );
  });

  tearDown(() {
    reset(dayQuery);
    reset(bookQuery);
  });

  group('empty day', () {
    setUp(() {
      when(() => dayQuery.selectBooksIds(dayId))
          .thenAnswer((_) => Stream.value([]));
    });

    test('day info', () async {
      List<DayBookInfo> dayInfo = await controller.dayInfo$.first;

      expect(dayInfo.length, 0);
    });

    test('books amount', () async {
      int booksAmount = await controller.booksAmount$.first;

      expect(booksAmount, 0);
    });
  });

  group('day with some read books', () {
    setUp(() {
      when(() => dayQuery.selectBooksIds(dayId))
          .thenAnswer((_) => Stream.value(['b1', 'b2']));
      when(() => bookQuery.selectTitle('b1'))
          .thenAnswer((_) => Stream.value('Title 1'));
      when(() => bookQuery.selectTitle('b2'))
          .thenAnswer((_) => Stream.value('Title 2'));
      when(() => dayQuery.selectReadPages(dayId, 'b1'))
          .thenAnswer((_) => Stream.value(50));
      when(() => dayQuery.selectReadPages(dayId, 'b2'))
          .thenAnswer((_) => Stream.value(100));
    });

    test('day info', () async {
      List<DayBookInfo> dayInfo = await controller.dayInfo$.first;

      expect(dayInfo[0].title, 'Title 1');
      expect(dayInfo[0].readPages, 50);
      expect(dayInfo[1].title, 'Title 2');
      expect(dayInfo[1].readPages, 100);
    });

    test('books amount', () async {
      int booksAmount = await controller.booksAmount$.first;

      expect(booksAmount, 2);
    });
  });
}
