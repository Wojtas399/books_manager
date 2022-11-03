import 'dart:typed_data';

import 'package:app/data/data_sources/firebase/entities/firebase_book.dart';
import 'package:app/data/data_sources/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/firebase/services/firebase_storage_service.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/device.dart';
import 'package:app/models/image_file.dart';
import 'package:app/utils/image_utils.dart';
import 'package:rxdart/rxdart.dart';

class BookDataSource implements BookInterface {
  late final FirebaseFirestoreBookService _firebaseFirestoreBookService;
  late final FirebaseStorageService _firebaseStorageService;
  late final Device _device;

  BookDataSource({
    required FirebaseFirestoreBookService firebaseFirestoreBookService,
    required FirebaseStorageService firebaseStorageService,
    required Device device,
  }) {
    _firebaseFirestoreBookService = firebaseFirestoreBookService;
    _firebaseStorageService = firebaseStorageService;
    _device = device;
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
    required ImageFile? imageFile,
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  }) async {
    final String mappedBookStatus =
        BookStatusMapper.mapFromEnumToString(status);
    String? imageFileNameWithoutExtension;
    if (imageFile != null) {
      imageFileNameWithoutExtension =
          ImageUtils.removeExtensionFromFileName(imageFile.name);
      await _firebaseStorageService.saveBookImageData(
        imageData: imageFile.data,
        fileName: imageFileNameWithoutExtension,
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
      imageFileName: imageFileNameWithoutExtension,
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

  @override
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

  Stream<Book?> _combineFirebaseBookWithImage(FirebaseBook? firebaseBook) {
    if (firebaseBook != null) {
      return _getImageDataForFirebaseBook(firebaseBook).map(
        (Uint8List? imageData) => _createBook(firebaseBook, imageData),
      );
    }
    return Stream.value(null);
  }

  Stream<List<Book>> _mapFirebaseBooksToBookModels(
    List<FirebaseBook> firebaseBooks,
  ) {
    final Iterable<Stream<Book?>> books$ =
        firebaseBooks.map(_combineFirebaseBookWithImage);
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

  Future<void> _deleteFirebaseBook(FirebaseBook firebaseBook) async {
    final String? imageFileName = firebaseBook.imageFileName;
    if (imageFileName != null) {
      await _firebaseStorageService.deleteBookImageData(
        fileName: imageFileName,
        userId: firebaseBook.userId,
      );
    }
    await _firebaseFirestoreBookService.deleteBook(
      userId: firebaseBook.userId,
      bookId: firebaseBook.id,
    );
  }

  Stream<Uint8List?> _getImageDataForFirebaseBook(FirebaseBook firebaseBook) {
    return _getInternetConnectionStatus().switchMap(
      (bool hasDeviceInternetConnection) {
        final String? imageFileName = firebaseBook.imageFileName;
        return imageFileName != null && hasDeviceInternetConnection == true
            ? _getImageData(imageFileName, firebaseBook.userId)
            : Stream.value(null);
      },
    );
  }

  Book _createBook(FirebaseBook firebaseBook, Uint8List? imageData) {
    final BookStatus bookStatus =
        BookStatusMapper.mapFromStringToEnum(firebaseBook.status);
    ImageFile? imageFile =
        _createImageFile(firebaseBook.imageFileName, imageData);
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

  ImageFile? _createImageFile(String? imageFileName, Uint8List? imageData) {
    ImageFile? imageFile;
    if (imageData != null && imageFileName != null) {
      imageFile = ImageFile(name: imageFileName, data: imageData);
    }
    return imageFile;
  }

  Stream<bool> _getInternetConnectionStatus() {
    return Rx.fromCallable(() async => await _device.hasInternetConnection());
  }

  Stream<Uint8List?> _getImageData(String fileName, String userId) {
    return Rx.fromCallable(
      () async => await _firebaseStorageService.loadBookImageData(
        fileName: fileName,
        userId: userId,
      ),
    );
  }
}
