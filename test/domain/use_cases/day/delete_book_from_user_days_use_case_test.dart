import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/use_cases/day/delete_book_from_user_days_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../mocks/domain/interfaces/mock_day_interface.dart';

void main() {
  final dayInterface = MockDayInterface();
  late DeleteBookFromUserDaysUseCase useCase;
  const String userId = 'u1';
  const String bookId = 'b1';

  Future<void> useCaseCall() async {
    await useCase.execute(userId: userId, bookId: bookId);
  }

  setUp(() {
    useCase = DeleteBookFromUserDaysUseCase(
      dayInterface: dayInterface,
    );
    dayInterface.mockDeleteDay();
    dayInterface.mockUpdateDay();
  });

  tearDown(() {
    reset(dayInterface);
  });

  test(
    'book is the only read book from day, should delete day',
    () async {
      final List<Day> userDays = [
        createDay(
          date: DateTime(2022, 10, 15),
          userId: userId,
          readBooks: [
            createReadBook(bookId: bookId, readPagesAmount: 100),
          ],
        ),
      ];
      dayInterface.mockGetUserDays(userDays: userDays);

      await useCaseCall();

      verify(
        () => dayInterface.deleteDay(
          userId: userId,
          date: DateTime(2022, 10, 15),
        ),
      ).called(1);
    },
  );

  test(
    'book is not the only read book from day, should delete book from list of read books and should update day',
    () async {
      final Day existingDay = createDay(
        date: DateTime(2022, 10, 15),
        userId: userId,
        readBooks: [
          createReadBook(bookId: bookId, readPagesAmount: 100),
          createReadBook(bookId: 'b2', readPagesAmount: 200),
        ],
      );
      final Day updatedDay = existingDay.copyWith(
        readBooks: [existingDay.readBooks.last],
      );
      final List<Day> userDays = [existingDay];
      dayInterface.mockGetUserDays(userDays: userDays);

      await useCaseCall();

      verify(
        () => dayInterface.updateDay(
          updatedDay: updatedDay,
        ),
      ).called(1);
    },
  );

  test(
    'book does not exist in list of read books from day, should do nothing',
    () async {
      final List<Day> userDays = [
        createDay(
          date: DateTime(2022, 10, 15),
          userId: userId,
          readBooks: [
            createReadBook(bookId: 'b2', readPagesAmount: 200),
          ],
        ),
        createDay(
          date: DateTime(2022, 10, 17),
          userId: userId,
          readBooks: [
            createReadBook(bookId: 'b3', readPagesAmount: 100),
          ],
        ),
      ];
      dayInterface.mockGetUserDays(userDays: userDays);

      await useCaseCall();

      verifyNever(
        () => dayInterface.deleteDay(
          userId: userId,
          date: any(named: 'date'),
        ),
      );
      verifyNever(
        () => dayInterface.updateDay(
          updatedDay: any(named: 'updatedDay'),
        ),
      );
    },
  );
}
