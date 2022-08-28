import '../../../interfaces/book_interface.dart';
import '../../entities/book.dart';

class GetBooksByUserIdUseCase {
  late final BookInterface _bookInterface;

  GetBooksByUserIdUseCase({
    required BookInterface bookInterface,
  }) {
    _bookInterface = bookInterface;
  }

  Stream<List<Book>> execute({required String userId}) {
    return _bookInterface.getBooksByUserId(userId: userId);
  }
}
