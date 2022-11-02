import 'package:app/data/repositories/day_repository.dart';
import 'package:app/domain/entities/day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/data_sources/mock_day_data_source.dart';

void main() {
  final dayDataSource = MockDayDataSource();
  late DayRepository repository;
  const String userId = 'u1';

  setUp(() {
    repository = DayRepository(dayDataSource: dayDataSource);
  });

  tearDown(() {
    reset(dayDataSource);
  });

  test(
    'get user days, should return stream with user days using method from data source responsible for getting these days',
    () async {
      final List<Day> expectedDays = [
        createDay(userId: userId, date: DateTime(2022, 9, 20)),
        createDay(userId: userId, date: DateTime(2022, 8, 10)),
      ];
      dayDataSource.mockGetUserDays(userDays: expectedDays);

      final Stream<List<Day>?> days$ = repository.getUserDays(userId: userId);

      expect(await days$.first, expectedDays);
    },
  );

  test(
    'get user days from month, should return stream with user days from given month using method from data source responsible for getting these days',
    () async {
      const int month = 9;
      const int year = 2022;
      final List<Day> expectedDays = [
        createDay(userId: userId, date: DateTime(year, month, 20)),
        createDay(userId: userId, date: DateTime(year, month, 10)),
      ];
      dayDataSource.mockGetUserDaysFromMonth(userDaysFromMonth: expectedDays);

      final Stream<List<Day>?> days$ = repository.getUserDaysFromMonth(
        userId: userId,
        month: month,
        year: year,
      );

      expect(await days$.first, expectedDays);
    },
  );

  test(
    'add new day, should call method from data source responsible for adding new day',
    () async {
      final Day dayToAdd = createDay(
        date: DateTime(2022, 5, 20),
        userId: userId,
      );
      dayDataSource.mockAddDay();

      await repository.addNewDay(day: dayToAdd);

      verify(
        () => dayDataSource.addDay(day: dayToAdd),
      ).called(1);
    },
  );

  test(
    'update day, should call method from data source responsible for updating day',
    () async {
      final Day updatedDay = createDay(
        date: DateTime(2022, 8, 10),
      );
      dayDataSource.mockUpdateDay();

      await repository.updateDay(updatedDay: updatedDay);

      verify(
        () => dayDataSource.updateDay(updatedDay: updatedDay),
      ).called(1);
    },
  );

  test(
    'delete day, should call method from data source responsible for deleting day',
    () async {
      final DateTime date = DateTime(2022, 8, 30);
      dayDataSource.mockDeleteDay();

      await repository.deleteDay(userId: userId, date: date);

      verify(
        () => dayDataSource.deleteDay(
          userId: userId,
          date: date,
        ),
      ).called(1);
    },
  );
}
