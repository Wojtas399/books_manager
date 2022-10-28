import 'package:app/domain/use_cases/book/get_all_user_books_use_case.dart';

import '../../../mocks/domain/interfaces/mock_book_interface.dart';

void main() {
  final bookInterface = MockBookInterface();
  final useCase = GetAllUserBooksUseCase(bookInterface: bookInterface);

  // test(
  //   'should return stream which contains books belonging to user',
  //   () async {
  //     const String userId = 'u1';
  //     final List<Book> books = [
  //       createBook(
  //         userId: userId,
  //         title: 'book1',
  //         author: 'author1',
  //       ),
  //       createBook(
  //         userId: userId,
  //         title: 'book2',
  //         author: 'author2',
  //       ),
  //     ];
  //     bookInterface.mockGetBooksByUserId(books: books);
  //
  //     final Stream<List<Book>?> books$ = useCase.execute(userId: userId);
  //
  //     expect(await books$.first, books);
  //   },
  // );
}
