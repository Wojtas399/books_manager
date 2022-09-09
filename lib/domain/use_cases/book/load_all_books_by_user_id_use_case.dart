import 'package:app/domain/interfaces/book_interface.dart';

class LoadAllBooksByUserIdUseCase {
  late final BookInterface _bookInterface;

  LoadAllBooksByUserIdUseCase({
    required BookInterface bookInterface,
  }) {
    _bookInterface = bookInterface;
  }

  Future<void> execute({required String userId}) async {
    await _bookInterface.loadAllBooksByUserId(userId: userId);
  }
}
