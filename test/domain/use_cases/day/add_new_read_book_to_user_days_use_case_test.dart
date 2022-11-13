import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/day/add_new_read_book_to_user_days_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/domain/interfaces/mock_day_interface.dart';
import '../../../mocks/providers/mock_date_provider.dart';

void main() {
  final dayInterface = MockDayInterface();
  final dateProvider = MockDateProvider();
  late AddNewReadBookToUserDaysUseCase useCase;
  const String userId = 'u1';
  final ReadBook readBook = createReadBook(bookId: 'b1', readPagesAmount: 100);
  final DateTime todayDate = DateTime(2022, 10, 18);

  setUp(() {
    useCase = AddNewReadBookToUserDaysUseCase(
      dayInterface: dayInterface,
      dateProvider: dateProvider,
    );
    dateProvider.mockGetNow(nowDateTime: todayDate);
  });

  tearDown(() {
    reset(dayInterface);
    reset(dateProvider);
  });

  test(
    'today date does not exist in user days, should call method responsible for adding new day with today date',
    () async {
      final List<Day> userDays = [];
      final Day dayToAdd = createDay(
        date: todayDate,
        userId: userId,
        readBooks: [readBook],
      );
      dayInterface.mockGetUserDays(userDays: userDays);
      dayInterface.mockAddNewDay();

      await useCase.execute(userId: userId, readBook: readBook);

      verify(
        () => dayInterface.addNewDay(day: dayToAdd),
      ).called(1);
    },
  );

  test(
    'today date exists in user days, book does not exist in read books, should call method responsible for updating day with with new read book',
    () async {
      final Day existingDay = createDay(
        date: todayDate,
        userId: userId,
        readBooks: [
          createReadBook(bookId: 'b2', readPagesAmount: 200),
        ],
      );
      final Day updatedDay = existingDay.copyWith(
        readBooks: [
          existingDay.readBooks.first,
          readBook,
        ],
      );
      final List<Day> userDays = [
        createDay(date: DateTime(2022, 10, 10)),
        existingDay,
      ];
      dayInterface.mockGetUserDays(userDays: userDays);
      dayInterface.mockUpdateDay();

      await useCase.execute(userId: userId, readBook: readBook);

      verify(
        () => dayInterface.updateDay(
          updatedDay: updatedDay,
        ),
      ).called(1);
    },
  );

  test(
    'today date exists in user days, book exists in read books, should call method responsible for updating day with updated read book',
    () async {
      final Day existingDay = createDay(
        date: todayDate,
        userId: userId,
        readBooks: [
          createReadBook(bookId: readBook.bookId, readPagesAmount: 20),
        ],
      );
      final ReadBook updatedReadBook = readBook.copyWith(
        readPagesAmount: readBook.readPagesAmount +
            existingDay.readBooks.first.readPagesAmount,
      );
      final Day updatedDay = existingDay.copyWith(
        readBooks: [updatedReadBook],
      );
      final List<Day> userDays = [
        createDay(date: DateTime(2022, 10, 10)),
        existingDay,
      ];
      dayInterface.mockGetUserDays(userDays: userDays);
      dayInterface.mockUpdateDay();

      await useCase.execute(userId: userId, readBook: readBook);

      verify(
        () => dayInterface.updateDay(
          updatedDay: updatedDay,
        ),
      ).called(1);
    },
  );
}
