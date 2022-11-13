import 'package:app/data/firebase/entities/firebase_day.dart';
import 'package:app/data/firebase/entities/firebase_read_book.dart';
import 'package:app/data/firebase/entities/firebase_user.dart';
import 'package:app/data/firebase/services/firebase_firestore_user_service.dart';
import 'package:app/data/mappers/date_mapper.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';
import 'package:app/domain/interfaces/day_interface.dart';

class DayRepository implements DayInterface {
  late final FirebaseFirestoreUserService _firebaseFirestoreUserService;

  DayRepository({
    required FirebaseFirestoreUserService firebaseFirestoreUserService,
  }) {
    _firebaseFirestoreUserService = firebaseFirestoreUserService;
  }

  @override
  Stream<List<Day>> getUserDays({required String userId}) {
    return _getUserFirebaseDays(userId).map((List<FirebaseDay>? firebaseDays) {
      if (firebaseDays == null) {
        return [];
      }
      return firebaseDays.map(_createDay).toList();
    });
  }

  @override
  Stream<List<Day>> getUserDaysFromMonth({
    required String userId,
    required int month,
    required int year,
  }) {
    return getUserDays(userId: userId).map(
      (List<Day> userDays) {
        return userDays
            .where(
              (Day day) => month == day.date.month && year == day.date.year,
            )
            .toList();
      },
    );
  }

  @override
  Future<void> addNewDay({required Day day}) async {
    final String userId = day.userId;
    final FirebaseDay firebaseDayToAdd = _createFirebaseDay(day);
    final List<FirebaseDay> days = await _loadUserFirebaseDays(userId);
    final List<FirebaseDay> updatedDays = _addDayToList(days, firebaseDayToAdd);
    await _firebaseFirestoreUserService.updateUser(
      userId: userId,
      daysOfReading: updatedDays,
    );
  }

  @override
  Future<void> updateDay({required Day updatedDay}) async {
    final String userId = updatedDay.userId;
    final FirebaseDay updatedFirebaseDay = _createFirebaseDay(updatedDay);
    final List<FirebaseDay> days = await _loadUserFirebaseDays(userId);
    final List<FirebaseDay> updatedDays =
        _updateDayInList(days, updatedFirebaseDay);
    await _firebaseFirestoreUserService.updateUser(
      userId: userId,
      daysOfReading: updatedDays,
    );
  }

  @override
  Future<void> deleteDay({
    required String userId,
    required DateTime date,
  }) async {
    final List<FirebaseDay> days = await _loadUserFirebaseDays(userId);
    final List<FirebaseDay> updatedDays = _removeDayFromList(
      days,
      DateMapper.mapFromDateTimeToString(date),
    );
    await _firebaseFirestoreUserService.updateUser(
      userId: userId,
      daysOfReading: updatedDays,
    );
  }

  Stream<List<FirebaseDay>?> _getUserFirebaseDays(String userId) {
    return _firebaseFirestoreUserService
        .getUser(userId: userId)
        .map((FirebaseUser? firebaseUser) => firebaseUser?.daysOfReading);
  }

  Future<List<FirebaseDay>> _loadUserFirebaseDays(String userId) async {
    return await _getUserFirebaseDays(userId).first ?? [];
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
