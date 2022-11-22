import 'dart:async';
import 'dart:typed_data';

import 'package:app/data/firebase/entities/firebase_book.dart';
import 'package:app/data/firebase/entities/firebase_doc_change.dart';
import 'package:app/data/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/firebase/services/firebase_storage_image_service.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/image.dart';
import 'package:app/models/state_repository.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class BookRepository extends StateRepository<Book> implements BookInterface {
  late final FirebaseFirestoreBookService _firebaseFirestoreBookService;
  late final FirebaseStorageImageService _firebaseStorageImageService;
  StreamSubscription<List<Book>>? _addedBooksListener;
  StreamSubscription<List<Book>>? _updatedBooksListener;
  StreamSubscription<List<String>>? _removedBookIdsListener;

  BookRepository({
    super.initialData,
    required FirebaseFirestoreBookService firebaseFirestoreBookService,
    required FirebaseStorageImageService firebaseStorageImageService,
  }) {
    _firebaseFirestoreBookService = firebaseFirestoreBookService;
    _firebaseStorageImageService = firebaseStorageImageService;
  }

  @override
  void initializeBooksOfUser({required String userId}) {
    final multiStream = StreamSplitter(
      _firebaseFirestoreBookService.getDocChangesOfAllBooksOfUser(
        userId: userId,
      ),
    );
    _setListenerForAddedBooks(multiStream.split());
    _setListenerForUpdatedBooks(multiStream.split());
    _setListenerForRemovedBooks(multiStream.split());
    multiStream.close();
  }

  @override
  Stream<Book?> getBook({required String bookId, required String userId}) {
    return dataStream$.map(
      (List<Book>? allBooks) => <Book?>[...?allBooks].firstWhere(
        (Book? book) => book?.id == bookId && book?.userId == userId,
        orElse: () => null,
      ),
    );
  }

  @override
  Stream<List<Book>?> getBooksOfUser({
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
  Future<void> deleteAllBooksOfUser({required String userId}) async {
    await _firebaseFirestoreBookService.deleteAllBooksOfUser(userId: userId);
    await _firebaseStorageImageService.deleteAllUserImages(userId: userId);
  }

  @override
  void dispose() {
    _addedBooksListener?.cancel();
    _updatedBooksListener?.cancel();
    _removedBookIdsListener?.cancel();
  }

  void _setListenerForAddedBooks(
    Stream<List<FirebaseDocChange<FirebaseBook>>> docChanges,
  ) {
    _addedBooksListener ??= docChanges
        .selectByDocChangeType(DocumentChangeType.added)
        .map(_mapDocChangesToFirebaseBooks)
        .switchMap(_mapFirebaseBooksToBooks)
        .listen(addEntities);
  }

  void _setListenerForUpdatedBooks(
    Stream<List<FirebaseDocChange<FirebaseBook>>> docChanges,
  ) {
    _updatedBooksListener ??= docChanges
        .selectByDocChangeType(DocumentChangeType.modified)
        .map(_mapDocChangesToFirebaseBooks)
        .switchMap(_mapFirebaseBooksToBooks)
        .listen(updateEntities);
  }

  void _setListenerForRemovedBooks(
    Stream<List<FirebaseDocChange<FirebaseBook>>> docChanges,
  ) {
    _removedBookIdsListener ??= docChanges
        .selectByDocChangeType(DocumentChangeType.removed)
        .map(_mapDocChangesToFirebaseBooks)
        .map(_selectIds)
        .listen(removeEntities);
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

  List<FirebaseBook> _mapDocChangesToFirebaseBooks(
    List<FirebaseDocChange<FirebaseBook>> docChanges,
  ) {
    return docChanges
        .map((FirebaseDocChange<FirebaseBook> docChange) => docChange.doc)
        .whereType<FirebaseBook>()
        .toList();
  }

  Stream<List<Book>> _mapFirebaseBooksToBooks(
    List<FirebaseBook> firebaseBooks,
  ) {
    return Rx.combineLatest(
      firebaseBooks.map(_combineFirebaseBookWithImage),
      (List<Book> books) => books,
    );
  }

  List<String> _selectIds(List<FirebaseBook> firebaseBooks) {
    return firebaseBooks
        .map((FirebaseBook firebaseBook) => firebaseBook.id)
        .toList();
  }

  Stream<Book> _combineFirebaseBookWithImage(FirebaseBook firebaseBook) {
    return Rx.fromCallable(() async {
      final Image? image = await _loadImageForFirebaseBook(firebaseBook);
      return _createBook(firebaseBook, image);
    });
  }

  Future<Image?> _loadImageForFirebaseBook(FirebaseBook firebaseBook) async {
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

extension _FirebaseBookChangesExtension
    on Stream<List<FirebaseDocChange<FirebaseBook>>> {
  Stream<List<FirebaseDocChange<FirebaseBook>>> selectByDocChangeType(
    DocumentChangeType expectedDocChangeType,
  ) {
    return map(
      (firebaseBookChanges) => firebaseBookChanges
          .where(
            (docChange) => docChange.docChangeType == expectedDocChangeType,
          )
          .toList(),
    );
  }
}
