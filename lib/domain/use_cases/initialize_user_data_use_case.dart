import 'package:app/interfaces/book_interface.dart';

class InitializeUserDataUseCase {
  late final BookInterface _bookInterface;

  InitializeUserDataUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({required String userId}) async {
    await _bookInterface.refreshUserBooks(userId: userId);
  }
}
