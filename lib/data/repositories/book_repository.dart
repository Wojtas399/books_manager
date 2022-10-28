import 'package:app/data/data_sources/book_data_source.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/image_file.dart';

class BookRepository implements BookInterface {
  late final BookDataSource _bookDataSource;

  BookRepository({required BookDataSource bookDataSource}) {
    _bookDataSource = bookDataSource;
  }

  @override
  Stream<Book?> getBook({
    required String bookId,
    required String userId,
  }) {
    return _bookDataSource.getBook(bookId: bookId, userId: userId);
  }

  @override
  Stream<List<Book>> getUserBooks({
    required String userId,
    BookStatus? bookStatus,
  }) {
    return _bookDataSource.getUserBooks(userId: userId, bookStatus: bookStatus);
  }

  @override
  Future<void> addNewBook({
    required String userId,
    required BookStatus status,
    required ImageFile? imageFile,
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  }) async {
    await _bookDataSource.addBook(
      userId: userId,
      status: status,
      imageFile: imageFile,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }

  @override
  Future<void> updateBook({
    required String bookId,
    required String userId,
    BookStatus? status,
    ImageFile? imageFile,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) async {
    await _bookDataSource.updateBook(
      bookId: bookId,
      userId: userId,
      status: status,
      imageFile: imageFile,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }

  @override
  Future<void> deleteBookImage({
    required String bookId,
    required String userId,
  }) async {
    await _bookDataSource.deleteBookImage(
      bookId: bookId,
      userId: userId,
    );
  }

  @override
  Future<void> deleteBook({
    required String bookId,
    required String userId,
  }) async {
    await _bookDataSource.deleteBook(
      bookId: bookId,
      userId: userId,
    );
  }

  @override
  Future<void> deleteAllUserBooks({required String userId}) async {
    final List<Book> allUserBooks = await getUserBooks(userId: userId).first;
    for (final Book book in allUserBooks) {
      await _bookDataSource.deleteBook(bookId: book.id, userId: userId);
    }
  }
}
