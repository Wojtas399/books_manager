import 'dart:async';
import 'dart:typed_data';

import 'package:app/data/firebase/entities/firebase_book.dart';
import 'package:app/data/firebase/entities/firebase_doc_change.dart';
import 'package:app/data/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/firebase/services/firebase_storage_image_service.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/custom_repository.dart';
import 'package:app/models/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookRepository extends CustomRepository<Book> implements BookInterface {
  late final FirebaseFirestoreBookService _firebaseFirestoreBookService;
  late final FirebaseStorageImageService _firebaseStorageImageService;
  StreamSubscription<List<FirebaseDocChange<FirebaseBook>>>?
      _docChangesListener;

  BookRepository({
    super.initialState,
    required FirebaseFirestoreBookService firebaseFirestoreBookService,
    required FirebaseStorageImageService firebaseStorageImageService,
  }) {
    _firebaseFirestoreBookService = firebaseFirestoreBookService;
    _firebaseStorageImageService = firebaseStorageImageService;
  }

  @override
  void initializeForUser({required String userId}) {
    _docChangesListener ??= _firebaseFirestoreBookService
        .getDocChangesOfAllUserBooks(userId: userId)
        .listen(_manageBooksChanges);
  }

  @override
  Stream<Book?> getBook({required String bookId, required String userId}) {
    return dataStream$.map(
      (List<Book>? allBooks) {
        final List<Book?> books = [...?allBooks];
        return books.firstWhere(
          (Book? book) => book?.id == bookId && book?.userId == userId,
          orElse: () => null,
        );
      },
    );
  }

  @override
  Stream<List<Book>?> getUserBooks({
    required String userId,
    BookStatus? bookStatus,
  }) {
    return dataStream$.map(
      (List<Book>? books) => books?.where(
        (Book book) {
          bool doesBookBelongToUser = book.userId == userId;
          if (bookStatus == null) {
            return doesBookBelongToUser;
          }
          return doesBookBelongToUser && book.status == bookStatus;
        },
      ).toList(),
    );
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
    final String? imageFileName = await _getBookImageFileName(bookId, userId);
    if (imageFileName != null) {
      await _firebaseStorageImageService.deleteImage(
        fileName: imageFileName,
        userId: userId,
      );
    }
    await _firebaseFirestoreBookService.deleteBook(
      userId: userId,
      bookId: bookId,
    );
  }

  @override
  Future<void> deleteAllUserBooks({required String userId}) async {
    await _firebaseFirestoreBookService.deleteAllUserBooks(userId: userId);
    await _firebaseStorageImageService.deleteAllUserImages(userId: userId);
  }

  @override
  void dispose() {
    _docChangesListener?.cancel();
  }

  Future<void> _manageBooksChanges(
    List<FirebaseDocChange<FirebaseBook>> docChanges,
  ) async {
    for (final FirebaseDocChange<FirebaseBook> docChange in docChanges) {
      final FirebaseBook? firebaseBook = docChange.doc;
      if (firebaseBook != null) {
        switch (docChange.docChangeType) {
          case DocumentChangeType.added:
            await _manageAddedFirebaseBook(firebaseBook);
            break;
          case DocumentChangeType.modified:
            await _manageModifiedFirebaseBook(firebaseBook);
            break;
          case DocumentChangeType.removed:
            _manageRemovedFirebaseBook(firebaseBook);
            break;
        }
      }
    }
  }

  Future<void> _manageAddedFirebaseBook(FirebaseBook firebaseBook) async {
    final Book? book = await _combineFirebaseBookWithImage(firebaseBook);
    if (book == null) {
      return;
    }
    addEntity(book);
  }

  Future<void> _manageModifiedFirebaseBook(FirebaseBook firebaseBook) async {
    final Book? book = await _combineFirebaseBookWithImage(firebaseBook);
    if (book == null) {
      return;
    }
    updateEntity(book);
  }

  void _manageRemovedFirebaseBook(FirebaseBook firebaseBook) {
    removeEntity(firebaseBook.id);
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
    return await _firebaseFirestoreBookService.loadBookImageFileName(
      bookId: bookId,
      userId: userId,
    );
  }

  Future<Book?> _combineFirebaseBookWithImage(
    FirebaseBook? firebaseBook,
  ) async {
    Book? book;
    if (firebaseBook != null) {
      final Image? image = await _loadImageForFirebaseBook(firebaseBook);
      book = _createBook(firebaseBook, image);
    }
    return book;
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
