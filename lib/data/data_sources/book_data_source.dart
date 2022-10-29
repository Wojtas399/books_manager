import 'dart:typed_data';

import 'package:app/data/data_sources/firebase/entities/firebase_book.dart';
import 'package:app/data/data_sources/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_storage_service.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/models/image_file.dart';
import 'package:rxdart/rxdart.dart';

class BookDataSource {
  late final FirebaseFirestoreBookService _firebaseFirestoreBookService;
  late final FirebaseStorageService _firebaseStorageService;

  BookDataSource({
    required FirebaseFirestoreBookService firebaseFirestoreBookService,
    required FirebaseStorageService firebaseStorageService,
  }) {
    _firebaseFirestoreBookService = firebaseFirestoreBookService;
    _firebaseStorageService = firebaseStorageService;
  }

  Stream<Book?> getBook({required String bookId, required String userId}) {
    return _firebaseFirestoreBookService
        .getBook(bookId: bookId, userId: userId)
        .switchMap(_loadImageForFirebaseBookAndConvertToBookModel);
  }

  Stream<List<Book>> getUserBooks({
    required String userId,
    BookStatus? bookStatus,
  }) {
    String? bookStatusAsStr;
    if (bookStatus != null) {
      bookStatusAsStr = BookStatusMapper.mapFromEnumToString(bookStatus);
    }
    return _firebaseFirestoreBookService
        .getUserBooks(userId: userId, bookStatus: bookStatusAsStr)
        .switchMap(_mapFirebaseBooksToBooks);
  }

  Future<void> addBook({
    required String userId,
    required BookStatus status,
    required ImageFile? imageFile,
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  }) async {
    final String mappedBookStatus =
        BookStatusMapper.mapFromEnumToString(status);
    if (imageFile != null) {
      await _firebaseStorageService.saveBookImageData(
        imageData: imageFile.data,
        fileName: imageFile.name,
        userId: userId,
      );
    }
    await _firebaseFirestoreBookService.addBook(
      userId: userId,
      status: mappedBookStatus,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
      imageFileName: imageFile?.name,
    );
  }

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
    String? statusAsStr;
    if (status != null) {
      statusAsStr = BookStatusMapper.mapFromEnumToString(status);
    }
    if (imageFile != null) {
      await _updateBookImage(bookId, userId, imageFile);
    }
    await _firebaseFirestoreBookService.updateBook(
      bookId: bookId,
      userId: userId,
      status: statusAsStr,
      imageFileName: imageFile?.name,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }

  Future<void> deleteBookImage({
    required String bookId,
    required String userId,
  }) async {
    final String? imageFileName = await _getBookImageFileName(bookId, userId);
    if (imageFileName != null) {
      await _firebaseStorageService.deleteBookImageData(
        fileName: imageFileName,
        userId: userId,
      );
      await _firebaseFirestoreBookService.updateBook(
        bookId: bookId,
        userId: userId,
        deletedImageFileName: true,
      );
    }
  }

  Future<void> deleteBook({
    required String bookId,
    required String userId,
  }) async {
    final String? imageFileName = await _getBookImageFileName(bookId, userId);
    if (imageFileName != null) {
      await _firebaseStorageService.deleteBookImageData(
        fileName: imageFileName,
        userId: userId,
      );
    }
    await _firebaseFirestoreBookService.deleteBook(
      userId: userId,
      bookId: bookId,
    );
  }

  Stream<Book?> _loadImageForFirebaseBookAndConvertToBookModel(
    FirebaseBook? firebaseBook,
  ) {
    final String? imageFileName = firebaseBook?.imageFileName;
    if (firebaseBook == null || imageFileName == null) {
      return Stream.value(null);
    }
    return Rx.fromCallable(
      () async => await _firebaseStorageService.loadBookImageData(
        fileName: imageFileName,
        userId: firebaseBook.userId,
      ),
    ).map(
      (Uint8List? imageData) => _createBook(firebaseBook, imageData),
    );
  }

  Stream<List<Book>> _mapFirebaseBooksToBooks(
    List<FirebaseBook> firebaseBooks,
  ) {
    final Iterable<Stream<Book?>> books$ =
        firebaseBooks.map(_loadImageForFirebaseBookAndConvertToBookModel);
    return Rx.combineLatest(
      books$,
      (List<Book?> books) => books.whereType<Book>().toList(),
    );
  }

  Future<void> _updateBookImage(
    String bookId,
    String userId,
    ImageFile newImageFile,
  ) async {
    final String? currentImageFileName =
        await _getBookImageFileName(bookId, userId);
    if (currentImageFileName != null) {
      await _firebaseStorageService.deleteBookImageData(
        fileName: currentImageFileName,
        userId: userId,
      );
    }
    await _firebaseStorageService.saveBookImageData(
      imageData: newImageFile.data,
      fileName: newImageFile.name,
      userId: userId,
    );
  }

  Future<String?> _getBookImageFileName(String bookId, String userId) async {
    final FirebaseBook? firebaseBook = await _firebaseFirestoreBookService
        .getBook(bookId: bookId, userId: userId)
        .first;
    return firebaseBook?.imageFileName;
  }

  Book _createBook(FirebaseBook firebaseBook, Uint8List? imageData) {
    final BookStatus bookStatus =
        BookStatusMapper.mapFromStringToEnum(firebaseBook.status);
    final String? imageFileName = firebaseBook.imageFileName;
    ImageFile? imageFile;
    if (imageData != null && imageFileName != null) {
      imageFile = ImageFile(name: imageFileName, data: imageData);
    }
    return Book(
      id: firebaseBook.id,
      userId: firebaseBook.userId,
      status: bookStatus,
      imageFile: imageFile,
      title: firebaseBook.title,
      author: firebaseBook.author,
      readPagesAmount: firebaseBook.readPagesAmount,
      allPagesAmount: firebaseBook.allPagesAmount,
    );
  }
}
