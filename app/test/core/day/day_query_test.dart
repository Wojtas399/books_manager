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
      createDay(id: 'd1', booksReadPages: booksReadPages),
    ]);
  });

  tearDownAll(() => allDays.close());

  group('selectBooksIds', () {
    test('should contain books ids from selected day', () async {
      List<String> booksIds = await query.selectBooksIds('d1').first;
      expect(booksIds[0], 'b1');
      expect(booksIds[1], 'b2');
    });
  });

  group('selectReadPages', () {
    test(
      'should be the read pages of selected book from selected day',
      () async {
        int? readPages = await query.selectReadPages('d1', 'b2').first;
        expect(readPages, 20);
      },
    );
  });
}
