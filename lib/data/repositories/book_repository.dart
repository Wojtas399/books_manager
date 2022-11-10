import 'dart:typed_data';

import 'package:app/data/data_sources/firebase/entities/firebase_book.dart';
import 'package:app/data/data_sources/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/firebase/services/firebase_storage_image_service.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/image.dart';
import 'package:rxdart/rxdart.dart';

class BookRepository implements BookInterface {
  late final FirebaseFirestoreBookService _firebaseFirestoreBookService;
  late final FirebaseStorageImageService _firebaseStorageImageService;

  BookRepository({
    required FirebaseFirestoreBookService firebaseFirestoreBookService,
    required FirebaseStorageImageService firebaseStorageImageService,
  }) {
    _firebaseFirestoreBookService = firebaseFirestoreBookService;
    _firebaseStorageImageService = firebaseStorageImageService;
  }

  @override
  Stream<Book?> getBook({required String bookId, required String userId}) {
    return _firebaseFirestoreBookService
        .getBook(bookId: bookId, userId: userId)
        .switchMap(_combineFirebaseBookWithImage);
  }

  @override
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
        .switchMap(_mapFirebaseBooksToBookModels);
  }

  @override
  Future<void> addNewBook({
    required String userId,
    required BookStatus status,
    required Image? image,
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  }) async {
    final String mappedBookStatus =
        BookStatusMapper.mapFromEnumToString(status);
    if (image != null) {
      await _firebaseStorageImageService.saveImage(
        image: image,
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
      imageFileName: image?.fileName,
    );
  }

  @override
  Future<void> updateBook({
    required String bookId,
    required String userId,
    BookStatus? status,
    Image? image,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) async {
    String? statusAsStr;
    if (status != null) {
      statusAsStr = BookStatusMapper.mapFromEnumToString(status);
    }
    if (image != null) {
      await _updateBookImage(bookId, userId, image);
    }
    await _firebaseFirestoreBookService.updateBook(
      bookId: bookId,
      userId: userId,
      status: statusAsStr,
      imageFileName: image?.fileName,
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
    final String? imageFileName = await _getBookImageFileName(bookId, userId);
    if (imageFileName != null) {
      await _firebaseStorageImageService.deleteImage(
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

  @override
  Future<void> deleteBook({
    required String bookId,
    required String userId,
  }) async {
    final FirebaseBook? firebaseBook = await _firebaseFirestoreBookService
        .getBook(bookId: bookId, userId: userId)
        .first;
    if (firebaseBook != null) {
      await _deleteFirebaseBook(firebaseBook);
    }
  }

  @override
  Future<void> deleteAllUserBooks({required String userId}) async {
    final List<FirebaseBook> allUserFirebaseBooks =
        await _firebaseFirestoreBookService.getUserBooks(userId: userId).first;
    for (final FirebaseBook firebaseBook in allUserFirebaseBooks) {
      await _deleteFirebaseBook(firebaseBook);
    }
  }

  Stream<Book?> _combineFirebaseBookWithImage(
    FirebaseBook? firebaseBook,
  ) async* {
    Book? book;
    if (firebaseBook != null) {
      final Image? image = await _loadImageForFirebaseBook(firebaseBook);
      book = _createBook(firebaseBook, image);
    }
    yield book;
  }

  Stream<List<Book>> _mapFirebaseBooksToBookModels(
    List<FirebaseBook> firebaseBooks,
  ) {
    if (firebaseBooks.isEmpty) {
      return Stream.value([]);
    }
    final Iterable<Stream<Book?>> books$ = firebaseBooks.map(
      _combineFirebaseBookWithImage,
    );
    return Rx.combineLatest(
      books$,
      (List<Book?> books) => books.whereType<Book>().toList(),
    );
  }

  Future<void> _updateBookImage(
    String bookId,
    String userId,
    Image newImage,
  ) async {
    final String? currentImageFileName =
        await _getBookImageFileName(bookId, userId);
    if (currentImageFileName != null) {
      await _firebaseStorageImageService.deleteImage(
        fileName: currentImageFileName,
        userId: userId,
      );
    }
    await _firebaseStorageImageService.saveImage(
      image: newImage,
      userId: userId,
    );
  }

  Future<String?> _getBookImageFileName(String bookId, String userId) async {
    final FirebaseBook? firebaseBook = await _firebaseFirestoreBookService
        .getBook(bookId: bookId, userId: userId)
        .first;
    return firebaseBook?.imageFileName;
  }

  Future<void> _deleteFirebaseBook(FirebaseBook firebaseBook) async {
    final String? imageFileName = firebaseBook.imageFileName;
    if (imageFileName != null) {
      await _firebaseStorageImageService.deleteImage(
        fileName: imageFileName,
        userId: firebaseBook.userId,
      );
    }
    await _firebaseFirestoreBookService.deleteBook(
      userId: firebaseBook.userId,
      bookId: firebaseBook.id,
    );
  }

  Future<Image?> _loadImageForFirebaseBook(
    FirebaseBook firebaseBook,
  ) async {
    final String? imageFileName = firebaseBook.imageFileName;
    if (imageFileName == null) {
      return null;
    }
    final Uint8List? imageData = await _firebaseStorageImageService.loadImage(
      fileName: imageFileName,
      userId: firebaseBook.userId,
    );
    if (imageData == null) {
      return null;
    }
    return Image(
      fileName: imageFileName,
      data: imageData,
    );
  }

  Book _createBook(FirebaseBook firebaseBook, Image? image) {
    final BookStatus bookStatus =
        BookStatusMapper.mapFromStringToEnum(firebaseBook.status);
    return Book(
      id: firebaseBook.id,
      userId: firebaseBook.userId,
      status: bookStatus,
      image: image,
      title: firebaseBook.title,
      author: firebaseBook.author,
      readPagesAmount: firebaseBook.readPagesAmount,
      allPagesAmount: firebaseBook.allPagesAmount,
    );
  }
}
