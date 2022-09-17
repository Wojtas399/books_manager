import 'dart:typed_data';

import 'package:app/data/data_sources/local_db/local_storage_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_book_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/mappers/book_mapper.dart';
import 'package:app/data/models/db_book.dart';

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

  Future<List<DbBook>> loadUserBooks({
    required String userId,
    String? bookStatus,
    SyncState? syncState,
  }) async {
    final List<SqliteBook> sqliteBooks = await _sqliteBookService.loadUserBooks(
      userId: userId,
      bookStatus: bookStatus,
      syncState: syncState,
    );
    return await _convertSqliteBooksToDbBooks(sqliteBooks);
  }

  Future<void> addBook({
    required DbBook dbBook,
    SyncState syncState = SyncState.none,
  }) async {
    final Uint8List? imageData = dbBook.imageData;
    await _sqliteBookService.addBook(
      sqliteBook: BookMapper.mapFromDbModelToSqliteModel(dbBook, syncState),
    );
    if (imageData != null) {
      await _localStorageService.saveBookImageData(
        imageData: imageData,
        userId: dbBook.userId,
        bookId: dbBook.id,
      );
    }
  }

  Future<DbBook> updateBookData({
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
    return BookMapper.mapFromSqliteModelToDbModel(updatedSqliteBook, imageData);
  }

  Future<DbBook> updateBookImage({
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
    return BookMapper.mapFromSqliteModelToDbModel(sqliteBook, imageData);
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

  Future<List<DbBook>> _convertSqliteBooksToDbBooks(
    List<SqliteBook> sqliteBooks,
  ) async {
    final List<DbBook> dbBooks = [];
    for (final SqliteBook sqliteBook in sqliteBooks) {
      final Uint8List? imageData = await _localStorageService.loadBookImageData(
        userId: sqliteBook.userId,
        bookId: sqliteBook.id,
      );
      dbBooks.add(
        BookMapper.mapFromSqliteModelToDbModel(sqliteBook, imageData),
      );
    }
    return dbBooks;
  }
}
