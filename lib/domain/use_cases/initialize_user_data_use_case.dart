import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/user_interface.dart';

class InitializeUserDataUseCase {
  late final UserInterface _userInterface;
  late final BookInterface _bookInterface;

  InitializeUserDataUseCase({
    required UserInterface userInterface,
    required BookInterface bookInterface,
  }) {
    _userInterface = userInterface;
    _bookInterface = bookInterface;
  }

  Future<void> execute({required String userId}) async {
    await _userInterface.refreshUser(userId: userId);
    await _bookInterface.refreshUserBooks(userId: userId);
    await _userInterface.loadUser(userId: userId);
  }
}
