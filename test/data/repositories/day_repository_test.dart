import 'package:app/data/repositories/day_repository.dart';
import 'package:app/domain/entities/day.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DayRepository repository;

  DayRepository createRepository({
    List<Day> days = const [],
  }) {
    return DayRepository(
      days: days,
    );
  }

  setUp(() {
    repository = createRepository();
  });

  test(
    'get user days, should return stream which contains days matching to user id',
    () async {
      const String userId = 'u1';
      final List<Day> days = [
        createDay(userId: 'u1', date: DateTime(2022, 9, 20)),
        createDay(userId: 'u2', date: DateTime(2022, 8, 15)),
        createDay(userId: 'u1', date: DateTime(2022, 7, 10)),
      ];
      final List<Day> expectedDays = [days.first, days.last];
      repository = createRepository(days: days);

      final Stream<List<Day>> days$ = repository.getUserDays(userId: userId);

      expect(await days$.first, expectedDays);
    },
  );
}
