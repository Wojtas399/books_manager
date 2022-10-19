import 'package:app/data/data_sources/remote_db/firebase/models/firebase_day.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_read_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_user.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';

class DayRemoteDbService {
  late final FirebaseFirestoreUserService _firebaseFirestoreUserService;

  DayRemoteDbService({
    required FirebaseFirestoreUserService firebaseFirestoreUserService,
  }) {
    _firebaseFirestoreUserService = firebaseFirestoreUserService;
  }

  Future<List<Day>> loadUserDays({required String userId}) async {
    final List<FirebaseDay> userFirebaseDays =
        await _loadUserDaysOfReading(userId);
    return userFirebaseDays.map(_createDay).toList();
  }

  Future<void> addDay({required Day day}) async {
    final String userId = day.userId;
    final FirebaseDay firebaseDayToAdd = _createFirebaseDay(day);
    final List<FirebaseDay> days = await _loadUserDaysOfReading(userId);
    final List<FirebaseDay> updatedDays = _addDayToList(days, firebaseDayToAdd);
    await _firebaseFirestoreUserService.updateUser(
      userId: userId,
      daysOfReading: updatedDays,
    );
  }

  Future<void> updateDay({required Day updatedDay}) async {
    final String userId = updatedDay.userId;
    final FirebaseDay updatedFirebaseDay = _createFirebaseDay(updatedDay);
    final List<FirebaseDay> days = await _loadUserDaysOfReading(userId);
    final List<FirebaseDay> updatedDays =
        _updateDayInList(days, updatedFirebaseDay);
    await _firebaseFirestoreUserService.updateUser(
      userId: userId,
      daysOfReading: updatedDays,
    );
  }

  Future<void> deleteDay({
    required String userId,
    required DateTime date,
  }) async {
    final List<FirebaseDay> days = await _loadUserDaysOfReading(userId);
    final List<FirebaseDay> updatedDays = _removeDayFromList(
      days,
      DateMapper.mapFromDateTimeToString(date),
    );
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

  Day _createDay(FirebaseDay firebaseDay) {
    return Day(
      userId: firebaseDay.userId,
      date: DateMapper.mapFromStringToDateTime(firebaseDay.date),
      readBooks: firebaseDay.readBooks.map(_createReadBook).toList(),
    );
  }

  FirebaseDay _createFirebaseDay(Day day) {
    return FirebaseDay(
      userId: day.userId,
      date: DateMapper.mapFromDateTimeToString(day.date),
      readBooks: day.readBooks.map(_createFirebaseReadBook).toList(),
    );
  }

  ReadBook _createReadBook(FirebaseReadBook firebaseReadBook) {
    return ReadBook(
      bookId: firebaseReadBook.bookId,
      readPagesAmount: firebaseReadBook.readPagesAmount,
    );
  }

  FirebaseReadBook _createFirebaseReadBook(ReadBook readBook) {
    return FirebaseReadBook(
      bookId: readBook.bookId,
      readPagesAmount: readBook.readPagesAmount,
    );
  }

  List<FirebaseDay> _addDayToList(
    List<FirebaseDay> days,
    FirebaseDay dayToAdd,
  ) {
    final List<FirebaseDay> updatedDays = [...days];
    updatedDays.add(dayToAdd);
    return updatedDays;
  }

  List<FirebaseDay> _updateDayInList(
    List<FirebaseDay> days,
    FirebaseDay updatedDay,
  ) {
    final List<FirebaseDay> updatedDays = [...days];
    final int dayIndex = updatedDays.indexWhere(
      (FirebaseDay day) => day.date == updatedDay.date,
    );
    updatedDays[dayIndex] = updatedDay;
    return updatedDays;
  }

  List<FirebaseDay> _removeDayFromList(
    List<FirebaseDay> days,
    String date,
  ) {
    final List<FirebaseDay> updatedDays = [...days];
    updatedDays.removeWhere(
      (FirebaseDay firebaseDay) => firebaseDay.date == date,
    );
    return updatedDays;
  }
}
