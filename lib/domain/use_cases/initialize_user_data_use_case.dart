import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';

class InitializeUserDataUseCase {
  late final UserInterface _userInterface;
  late final BookInterface _bookInterface;
  late final DayInterface _dayInterface;

  InitializeUserDataUseCase({
    required UserInterface userInterface,
    required BookInterface bookInterface,
    required DayInterface dayInterface,
  }) {
    _userInterface = userInterface;
    _bookInterface = bookInterface;
    _dayInterface = dayInterface;
  }

  Future<void> execute({required String userId}) async {
    await _userInterface.refreshUser(userId: userId);
    await _bookInterface.refreshUserBooks(userId: userId);
    await _dayInterface.initializeForUser(userId: userId);
    await _userInterface.loadUser(userId: userId);
  }
}
