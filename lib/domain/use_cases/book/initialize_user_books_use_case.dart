import 'package:app/domain/interfaces/book_interface.dart';

class InitializeUserBooksUseCase {
  late final BookInterface _bookInterface;

  InitializeUserBooksUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  void execute({required String userId}) {
    _bookInterface.initializeForUser(userId: userId);
  }
}
