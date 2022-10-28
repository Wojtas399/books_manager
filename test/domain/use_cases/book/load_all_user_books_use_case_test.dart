import 'package:app/domain/use_cases/book/load_all_user_books_use_case.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final useCase = LoadAllUserBooksUseCase(bookInterface: bookInterface);

  // test(
  //   'should call methods responsible for loading all books belonging to user',
  //   () async {
  //     const String userId = 'u1';
  //     bookInterface.mockLoadUserBooks();
  //
  //     await useCase.execute(userId: userId);
  //
  //     verify(
  //       () => bookInterface.loadUserBooks(userId: userId),
  //     ).called(1);
  //   },
  // );
}
