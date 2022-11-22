import 'package:app/domain/interfaces/book_interface.dart';

class InitializeBooksOfUserUseCase {
  late final BookInterface _bookInterface;

  InitializeBooksOfUserUseCase({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
  }

  void execute({required String userId}) {
    _bookInterface.initializeBooksOfUser(userId: userId);
  }
}
