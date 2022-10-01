import 'package:app/domain/interfaces/day_interface.dart';

class AddNewReadPagesUseCase {
  late final DayInterface _dayInterface;

  AddNewReadPagesUseCase({required DayInterface dayInterface}) {
    _dayInterface = dayInterface;
  }

  Future<void> execute({
    required String userId,
    required DateTime date,
    required String bookId,
    required int amountOfReadPagesToAdd,
  }) async {
    await _dayInterface.addNewReadPages(
      userId: userId,
      date: date,
      bookId: bookId,
      amountOfReadPagesToAdd: amountOfReadPagesToAdd,
    );
  }
}
