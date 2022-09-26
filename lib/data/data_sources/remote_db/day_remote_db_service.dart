import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_read_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/data/mappers/day_mapper.dart';
import 'package:app/data/models/db_day.dart';
import 'package:app/providers/date_provider.dart';
import 'package:app/utils/date_utils.dart';

class DayRemoteDbService {
  late final FirebaseFirestoreUserService _firebaseFirestoreUserService;
  late final DateProvider _dateProvider;

  DayRemoteDbService({
    required FirebaseFirestoreUserService firebaseFirestoreUserService,
    required DateProvider dateProvider,
  }) {
    _firebaseFirestoreUserService = firebaseFirestoreUserService;
    _dateProvider = dateProvider;
  }

  Future<List<DbDay>> loadUserDays({required String userId}) async {
    final FirebaseUser firebaseUser =
        await _firebaseFirestoreUserService.loadUser(userId: userId);
    final List<FirebaseDay> userDays = firebaseUser.daysOfReading;
    return userDays.map(DayMapper.mapFromFirebaseModelToDbModel).toList();
  }

  Future<void> addUserReadBook({
    required String userId,
    required String bookId,
    required int readPagesAmount,
  }) async {
    final FirebaseUser user = await _firebaseFirestoreUserService.loadUser(
      userId: userId,
    );
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
    final List<FirebaseReadBook> readBooks = day.readBooks;
    final List<String> readBooksIds =
        readBooks.map((FirebaseReadBook readBook) => readBook.bookId).toList();
    FirebaseDay updatedDay = day;
    if (readBooksIds.contains(bookId)) {
      updatedDay = _updateBookReadPagesAmountInDay(
        bookId: bookId,
        readPagesAmountToAdd: readPagesAmount,
        day: day,
      );
    } else {
      updatedDay = _addNewReadBookToDay(
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
    final FirebaseReadBook newReadBook = FirebaseReadBook(
      bookId: bookId,
      readPagesAmount: readPagesAmount,
    );
    final FirebaseDay newDay = FirebaseDay(
      userId: userId,
      date: _getNowDateAsStr(),
      readBooks: [newReadBook],
    );
    return newDay;
  }

  FirebaseDay _updateBookReadPagesAmountInDay({
    required String bookId,
    required int readPagesAmountToAdd,
    required FirebaseDay day,
  }) {
    final List<FirebaseReadBook> updatedReadBooks = [...day.readBooks];
    final int readBookIndex = updatedReadBooks.indexWhere(
      (FirebaseReadBook readBook) => readBook.bookId == bookId,
    );
    final FirebaseReadBook readBook = updatedReadBooks[readBookIndex];
    updatedReadBooks[readBookIndex] = readBook.copyWith(
      readPagesAmount: readBook.readPagesAmount + readPagesAmountToAdd,
    );
    return day.copyWith(
      readBooks: updatedReadBooks,
    );
  }

  FirebaseDay _addNewReadBookToDay({
    required String bookId,
    required int readPagesAmount,
    required FirebaseDay day,
  }) {
    final List<FirebaseReadBook> updatedReadBooks = [...day.readBooks];
    final FirebaseReadBook newReadBook = FirebaseReadBook(
      bookId: bookId,
      readPagesAmount: readPagesAmount,
    );
    updatedReadBooks.add(newReadBook);
    return day.copyWith(
      readBooks: updatedReadBooks,
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