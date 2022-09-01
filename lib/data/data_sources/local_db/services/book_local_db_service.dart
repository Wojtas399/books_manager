import 'dart:typed_data';

import 'package:app/data/data_sources/local_db/local_storage/local_storage_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_book_service.dart';
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

  Future<List<DbBook>> loadBooksByUserId({required String userId}) async {
    final List<DbBook> dbBooksWithoutLoadedImages =
        await _sqliteBookService.loadBooksByUserId(userId: userId);
    return await _loadImageForEachBook(dbBooksWithoutLoadedImages);
  }

  Future<DbBook> addBook({required DbBook dbBook}) async {
    final DbBook addedBook = await _sqliteBookService.addBook(dbBook);
    final String? bookId = addedBook.id;
    final Uint8List? imageData = dbBook.imageData;
    if (imageData != null && bookId != null) {
      await _localStorageService.saveBookImageToFile(
        imageData: imageData,
        bookId: bookId,
        userId: dbBook.userId,
      );
    }
    return addedBook;
  }

  Future<List<DbBook>> _loadImageForEachBook(List<DbBook> dbBooks) async {
    final List<DbBook> dbBooksWithLoadedImages = [];
    for (final DbBook dbBook in dbBooks) {
      final DbBook dbBookWithLoadedImage = await _loadImageForBook(dbBook);
      dbBooksWithLoadedImages.add(dbBookWithLoadedImage);
    }
    return dbBooksWithLoadedImages;
  }

  Future<DbBook> _loadImageForBook(DbBook dbBook) async {
    final String? dbBookId = dbBook.id;
    Uint8List? imageData;
    if (dbBookId != null) {
      imageData = await _localStorageService.loadBookImageDataFromFile(
        userId: dbBook.userId,
        bookId: dbBookId,
      );
    }
    return dbBook.copyWith(imageData: imageData);
  }
}
