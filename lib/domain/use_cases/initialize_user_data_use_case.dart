import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/day_interface.dart';

class InitializeUserDataUseCase {
  late final BookInterface _bookInterface;
  late final DayInterface _dayInterface;

  InitializeUserDataUseCase({
    required BookInterface bookInterface,
    required DayInterface dayInterface,
  }) {
    _bookInterface = bookInterface;
    _dayInterface = dayInterface;
  }

  Future<void> execute({required String userId}) async {
    // await _bookInterface.initializeForUser(userId: userId);
    await _dayInterface.initializeForUser(userId: userId);
  }
}
