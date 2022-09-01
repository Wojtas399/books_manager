import 'dart:typed_data';

import 'package:app/data/data_sources/remote_db/firebase/services/fire_book_service.dart';
import 'package:app/data/models/db_book.dart';

class BookRemoteDbService {
  late final FirebaseBookService _firebaseBookService;

  BookRemoteDbService({
    required FirebaseBookService firebaseBookService,
  }) {
    _firebaseBookService = firebaseBookService;
  }

  Future<List<DbBook>> loadBooksByUserId({required String userId}) async {
    final List<DbBook> dbBooksWithoutLoadedImages =
        await _firebaseBookService.loadBooksByUserId(userId: userId);
    return await _loadImageForEachBook(dbBooksWithoutLoadedImages);
  }

  Future<void> addBook({required DbBook dbBook}) async {
    await _firebaseBookService.addBook(dbBook: dbBook);
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
      imageData = await _firebaseBookService.loadBookImageData(
        userId: dbBook.userId,
        bookId: dbBookId,
      );
    }
    return dbBook.copyWith(imageData: imageData);
  }
}
