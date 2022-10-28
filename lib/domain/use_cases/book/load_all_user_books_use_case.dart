import 'package:app/domain/interfaces/book_interface.dart';

class LoadAllUserBooksUseCase {
  late final BookInterface _bookInterface;

  LoadAllUserBooksUseCase({
    required BookInterface bookInterface,
  }) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({required String userId}) async {
    // await _bookInterface.loadUserBooks(userId: userId);
  }
}
