import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/mappers/user_mapper.dart';
import 'package:app/data/models/db_user.dart';
import 'package:app/providers/date_provider.dart';
import 'package:app/utils/date_utils.dart';

class UserRemoteDbService {
  late final FirebaseFirestoreUserService _firebaseFirestoreUserService;
  late final DateProvider _dateProvider;

  UserRemoteDbService({
    required FirebaseFirestoreUserService firebaseFirestoreUserService,
    required DateProvider dateProvider,
  }) {
    _firebaseFirestoreUserService = firebaseFirestoreUserService;
    _dateProvider = dateProvider;
  }

  Future<DbUser> loadUser({required String userId}) async {
    final FirebaseUser firebaseUser = await _loadFirebaseUserById(userId);
    return UserMapper.mapFromFirebaseModelToDbModel(firebaseUser);
  }

  Future<void> addUser({required DbUser dbUser}) async {
    final FirebaseUser firebaseUser =
        UserMapper.mapFromDbModelToFirebaseModel(dbUser: dbUser);
    await _firebaseFirestoreUserService.addUser(firebaseUser: firebaseUser);
  }

  Future<void> updateUser({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) async {
    await _firebaseFirestoreUserService.updateUser(
      userId: userId,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
  }

  Future<void> addReadPagesForUser({
    required String userId,
    required String bookId,
    required int readPagesAmount,
  }) async {
    final FirebaseUser user = await _loadFirebaseUserById(userId);
    final List<FirebaseDay> updatedDays = [...user.daysOfReading];
    final FirebaseDay latestDay = _getLatestDay(user.daysOfReading);
    final String nowStr = _getNowDateAsStr();
    if (latestDay.date == nowStr) {
      final int dayIndex = updatedDays.indexOf(latestDay);
      final FirebaseDay updatedDay = _updateReadBooksInDay(
        bookId: bookId,
        readPagesAmount: readPagesAmount,
        day: latestDay,
      );
      updatedDays[dayIndex] = updatedDay;
    } else {
      final FirebaseDay newDay = _createNewFirebaseDay(
        userId: userId,
        bookId: bookId,
        readPagesAmount: readPagesAmount,
      );
      updatedDays.add(newDay);
    }
    await _firebaseFirestoreUserService.updateUser(
      userId: userId,
      daysOfReading: updatedDays,
    );
  }

  Future<void> deleteUser({required String userId}) async {
    await _firebaseFirestoreUserService.deleteUser(userId: userId);
  }

  Future<FirebaseUser> _loadFirebaseUserById(String userId) async {
    return await _firebaseFirestoreUserService.loadUser(userId: userId);
  }

  FirebaseDay _getLatestDay(List<FirebaseDay> allDays) {
    FirebaseDay latestDay = allDays.first;
    DateTime latestDate = _mapStringToDateTime(latestDay.date);
    for (final FirebaseDay day in allDays) {
      final DateTime date = _mapStringToDateTime(day.date);
      if (DateUtils.isDate1LaterThanDate2(date1: date, date2: latestDate)) {
        latestDay = day;
        latestDate = date;
      }
    }
    return latestDay;
  }

  FirebaseDay _updateReadBooksInDay({
    required String bookId,
    required int readPagesAmount,
    required FirebaseDay day,
  }) {
    final List<FirebaseDayBook> readBooks = day.booksWithReadPages;
    final List<String> readBooksIds = readBooks
        .map((FirebaseDayBook dayBook) => dayBook.bookId)
        .toSet()
        .toList();
    FirebaseDay updatedDay = day;
    if (readBooksIds.contains(bookId)) {
      updatedDay = _updateBookReadPagesAmountInDay(
        bookId: bookId,
        readPagesAmountToAdd: readPagesAmount,
        day: day,
      );
    } else {
      updatedDay = _addNewDayBookToDay(
        bookId: bookId,
        readPagesAmount: readPagesAmount,
        day: day,
      );
    }
    return updatedDay;
  }

  FirebaseDay _createNewFirebaseDay({
    required String userId,
    required String bookId,
    required int readPagesAmount,
  }) {
    final FirebaseDayBook newReadBook = FirebaseDayBook(
      bookId: bookId,
      readPagesAmount: readPagesAmount,
    );
    final FirebaseDay newDay = FirebaseDay(
      userId: userId,
      date: _getNowDateAsStr(),
      booksWithReadPages: [newReadBook],
    );
    return newDay;
  }

  FirebaseDay _updateBookReadPagesAmountInDay({
    required String bookId,
    required int readPagesAmountToAdd,
    required FirebaseDay day,
  }) {
    final List<FirebaseDayBook> updatedReadBooks = [...day.booksWithReadPages];
    final int readBookIndex = updatedReadBooks.indexWhere(
      (FirebaseDayBook dayBook) => dayBook.bookId == bookId,
    );
    final FirebaseDayBook readBook = updatedReadBooks[readBookIndex];
    updatedReadBooks[readBookIndex] = readBook.copyWith(
      readPagesAmount: readBook.readPagesAmount + readPagesAmountToAdd,
    );
    return day.copyWith(
      booksWithReadPages: updatedReadBooks,
    );
  }

  FirebaseDay _addNewDayBookToDay({
    required String bookId,
    required int readPagesAmount,
    required FirebaseDay day,
  }) {
    final List<FirebaseDayBook> updatedReadBooks = [...day.booksWithReadPages];
    final FirebaseDayBook newReadBook = FirebaseDayBook(
      bookId: bookId,
      readPagesAmount: readPagesAmount,
    );
    updatedReadBooks.add(newReadBook);
    return day.copyWith(
      booksWithReadPages: updatedReadBooks,
    );
  }

  String _getNowDateAsStr() {
    return DateMapper.mapFromDateTimeToString(
      _dateProvider.getNow(),
    );
  }

  DateTime _mapStringToDateTime(String dateStr) {
    return DateMapper.mapFromStringToDateTime(dateStr);
  }
}
