import 'package:app/domain/use_cases/day/add_new_read_pages_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/interfaces/mock_day_interface.dart';

void main() {
  final dayInterface = MockDayInterface();
  final useCase = AddNewReadPagesUseCase(dayInterface: dayInterface);

  test(
    'should call method responsible for adding new read pages',
    () async {
      const String userId = 'u1';
      final DateTime date = DateTime(2022, 9, 20);
      const String bookId = 'b1';
      const int amountOfReadPagesToAdd = 100;
      dayInterface.mockAddNewReadPages();

      await useCase.execute(
        userId: userId,
        date: date,
        bookId: bookId,
        amountOfReadPagesToAdd: amountOfReadPagesToAdd,
      );

      verify(
        () => dayInterface.addNewReadPages(
          userId: userId,
          date: date,
          bookId: bookId,
          amountOfReadPagesToAdd: amountOfReadPagesToAdd,
        ),
      ).called(1);
    },
  );
}
