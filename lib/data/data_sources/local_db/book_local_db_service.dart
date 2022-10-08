import 'dart:typed_data';

import 'package:app/data/data_sources/local_db/local_storage_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_book_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/domain/entities/book.dart';

class BookLocalDbService {
  late final SqliteBookService _sqliteBookService;
  late final LocalStorageService _localStorageService;

  BookLocalDbService({
    required SqliteBookService sqliteBookService,
    required LocalStorageService localStorageService,
  }) {
    _sqliteBookService = sqliteBookService;
    _localStorageService = localStorageService;
  }

  Future<List<Book>> loadUserBooks({
    required String userId,
    String? bookStatus,
    SyncState? syncState,
  }) async {
    final List<SqliteBook> sqliteBooks = await _sqliteBookService.loadUserBooks(
      userId: userId,
      bookStatus: bookStatus,
      syncState: syncState,
    );
    return await _convertSqliteBooksToBooks(sqliteBooks);
  }

  Future<void> addBook({
    required Book book,
    SyncState syncState = SyncState.none,
  }) async {
    final Uint8List? imageData = book.imageData;
    await _sqliteBookService.addBook(
      sqliteBook: _createSqliteBook(book, syncState),
    );
    if (imageData != null) {
      await _localStorageService.saveBookImageData(
        imageData: imageData,
        userId: book.userId,
        bookId: book.id,
      );
    }
  }

  Future<Book> updateBookData({
    required String bookId,
    String? status,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    SyncState? syncState,
  }) async {
    final SqliteBook updatedSqliteBook = await _sqliteBookService.updateBook(
      bookId: bookId,
      status: status,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
      syncState: syncState,
    );
    final Uint8List? imageData = await _localStorageService.loadBookImageData(
      userId: updatedSqliteBook.userId,
      bookId: bookId,
    );
    return _createBook(updatedSqliteBook, imageData);
  }

  Future<Book> updateBookImage({
    required String bookId,
    required String userId,
    required Uint8List? imageData,
  }) async {
    if (imageData == null) {
      await _localStorageService.deleteBookImageData(
        userId: userId,
        bookId: bookId,
      );
    } else {
      await _localStorageService.saveBookImageData(
        imageData: imageData,
        userId: userId,
        bookId: bookId,
      );
    }
    final SqliteBook sqliteBook = await _sqliteBookService.loadBook(
      bookId: bookId,
    );
    return _createBook(sqliteBook, imageData);
  }

  Future<void> deleteBook({
    required String userId,
    required String bookId,
  }) async {
    await _sqliteBookService.deleteBook(bookId: bookId);
    await _localStorageService.deleteBookImageData(
      userId: userId,
      bookId: bookId,
    );
  }

  Future<List<Book>> _convertSqliteBooksToBooks(
    List<SqliteBook> sqliteBooks,
  ) async {
    final List<Book> books = [];
    for (final SqliteBook sqliteBook in sqliteBooks) {
      final Uint8List? imageData = await _localStorageService.loadBookImageData(
        userId: sqliteBook.userId,
        bookId: sqliteBook.id,
      );
      books.add(
        _createBook(sqliteBook, imageData),
      );
    }
    return books;
  }

  Book _createBook(SqliteBook sqliteBook, Uint8List? imageDate) {
    return Book(
      id: sqliteBook.id,
      userId: sqliteBook.userId,
      status: BookStatusMapper.mapFromStringToEnum(sqliteBook.status),
      imageData: imageDate,
      title: sqliteBook.title,
      author: sqliteBook.author,
      readPagesAmount: sqliteBook.readPagesAmount,
      allPagesAmount: sqliteBook.allPagesAmount,
    );
  }

  SqliteBook _createSqliteBook(Book book, SyncState syncState) {
    return SqliteBook(
      id: book.id,
      userId: book.userId,
      status: BookStatusMapper.mapFromEnumToString(book.status),
      title: book.title,
      author: book.author,
      readPagesAmount: book.readPagesAmount,
      allPagesAmount: book.allPagesAmount,
      syncState: syncState,
    );
  }
}
