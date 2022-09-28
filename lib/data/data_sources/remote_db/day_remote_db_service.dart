import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_read_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/data/mappers/day_mapper.dart';
import 'package:app/data/mappers/read_book_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/data/models/db_read_book.dart';

class DayRemoteDbService {
  late final FirebaseFirestoreUserService _firebaseFirestoreUserService;

  DayRemoteDbService({
    required FirebaseFirestoreUserService firebaseFirestoreUserService,
  }) {
    _firebaseFirestoreUserService = firebaseFirestoreUserService;
  }

  Future<List<DbDay>> loadUserDays({required String userId}) async {
    final List<FirebaseDay> userDays = await _loadUserDaysOfReading(userId);
    return userDays.map(DayMapper.mapFromFirebaseModelToDbModel).toList();
  }

  Future<void> addUserReadBook({
    required DbReadBook dbReadBook,
    required String userId,
    required String date,
  }) async {
    final List<FirebaseDay> userDays = await _loadUserDaysOfReading(userId);
    final List<FirebaseDay> updatedDays = [...userDays];
    final FirebaseReadBook firebaseReadBook =
        ReadBookMapper.mapFromDbModelToFirebaseModel(dbReadBook);
    if (updatedDays.containsDate(date)) {
      final int dayIndex = updatedDays.indexOfDate(date);
      final FirebaseDay updatedDay =
          _addReadBookToDay(firebaseReadBook, updatedDays[dayIndex]);
      updatedDays[dayIndex] = updatedDay;
    } else {
      final FirebaseDay newDay =
          _createNewFirebaseDay(userId, date, firebaseReadBook);
      updatedDays.add(newDay);
    }
    await _firebaseFirestoreUserService.updateUser(
      userId: userId,
      daysOfReading: updatedDays,
    );
  }

  Future<void> updateBookReadPagesAmountInDay({
    required DbReadBook updatedDbReadBook,
    required String userId,
    required String date,
  }) async {
    final List<FirebaseDay> userDays = await _loadUserDaysOfReading(userId);
    final List<FirebaseDay> updatedDays = [...userDays];
    if (!updatedDays.containsDate(date)) {
      throw "(Firebase firestore) There is no day with date $date in user's days of reading";
    }
    final FirebaseReadBook updatedReadBook =
        ReadBookMapper.mapFromDbModelToFirebaseModel(updatedDbReadBook);
    final int dayIndex = updatedDays.indexOfDate(date);
    final FirebaseDay updatedDay = _updateReadBookInDay(
      updatedReadBook,
      updatedDays[dayIndex],
    );
    updatedDays[dayIndex] = updatedDay;
    await _firebaseFirestoreUserService.updateUser(
      userId: userId,
      daysOfReading: updatedDays,
    );
  }

  Future<List<FirebaseDay>> _loadUserDaysOfReading(String userId) async {
    final FirebaseUser firebaseUser =
        await _firebaseFirestoreUserService.loadUser(userId: userId);
    return firebaseUser.daysOfReading;
  }

  FirebaseDay _addReadBookToDay(FirebaseReadBook readBook, FirebaseDay day) {
    if (day.containsBook(readBook.bookId)) {
      throw '(Firebase firestore) Book with id ${readBook.bookId} already exists in day ${day.date}';
    }
    final List<FirebaseReadBook> updatedReadBooks = [...day.readBooks];
    updatedReadBooks.add(readBook);
    return day.copyWith(
      readBooks: updatedReadBooks,
    );
  }

  FirebaseDay _updateReadBookInDay(
    FirebaseReadBook updatedReadBook,
    FirebaseDay day,
  ) {
    final String bookId = updatedReadBook.bookId;
    if (!day.containsBook(bookId)) {
      throw "(Firebase firestore) There is no book with id $bookId in read books from the day ${day.date}";
    }
    final List<FirebaseReadBook> updatedReadBooks = [...day.readBooks];
    final int readBookIndex = updatedReadBooks.indexOfBook(bookId);
    updatedReadBooks[readBookIndex] = updatedReadBook;
    return day.copyWith(
      readBooks: updatedReadBooks,
    );
  }

  FirebaseDay _createNewFirebaseDay(
    String userId,
    String date,
    FirebaseReadBook firebaseReadBook,
  ) {
    return FirebaseDay(
      userId: userId,
      date: date,
      readBooks: [firebaseReadBook],
    );
  }
}

extension _FirebaseDaysExtensions on List<FirebaseDay> {
  bool containsDate(String date) {
    final List<String> datesFromDays =
        map((FirebaseDay firebaseDay) => firebaseDay.date).toList();
    return datesFromDays.contains(date);
  }

  int indexOfDate(String date) {
    return indexWhere((FirebaseDay firebaseDay) => firebaseDay.date == date);
  }
}

extension _FirebaseDayExtensions on FirebaseDay {
  bool containsBook(String bookId) {
    final List<String> idsOfReadBooksFromDay = readBooks
        .map((FirebaseReadBook firebaseReadBook) => firebaseReadBook.bookId)
        .toList();
    return idsOfReadBooksFromDay.contains(bookId);
  }
}

extension _FirebaseReadBooksExtensions on List<FirebaseReadBook> {
  int indexOfBook(String bookId) {
    return indexWhere(
      (FirebaseReadBook firebaseReadBook) => firebaseReadBook.bookId == bookId,
    );
  }
}
