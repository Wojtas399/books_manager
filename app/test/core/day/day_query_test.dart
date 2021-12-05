import 'package:app/core/day/day_model.dart';
import 'package:app/core/day/day_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  BehaviorSubject<List<Day>> allDays = BehaviorSubject();
  DayQuery query = DayQuery(allDays: allDays);

  setUp(() {
    Map<String, int> booksReadPages = Map();
    booksReadPages['b1'] = 40;
    booksReadPages['b2'] = 20;
    allDays.add([
      createDay(id: '18.11.2021', booksReadPages: booksReadPages),
      createDay(id: '15.10.2021'),
    ]);
  });

  tearDownAll(() => allDays.close());

  group('selectBooksIds', () {
    test('should return books ids from selected day', () async {
      List<String> booksIds = await query.selectBooksIds('18.11.2021').first;
      expect(booksIds[0], 'b1');
      expect(booksIds[1], 'b2');
    });
  });

  group('selectReadPages', () {
    test(
      'should return the amount of read pages of selected book from selected day',
      () async {
        int? readPages = await query.selectReadPages('18.11.2021', 'b2').first;
        expect(readPages, 20);
      },
    );
  });

  group('selectTheAmountOfReadPagesFromTheDay', () {
    test('should return the amount of read pages from selected day', () async {
      int readPages =
          await query.selectTheAmountOfReadPagesFromTheDay('18.11.2021').first;
      expect(readPages, 60);
    });
  });

  group('selectDaysFromTheMonth', () {
    test('should return days from the month', () async {
      List<Day> days = await query.selectDaysFromTheMonth(11).first;
      expect(days.length, 1);
      expect(days[0].id, '18.11.2021');
    });
  });
}
