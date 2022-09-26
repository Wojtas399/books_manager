import 'package:app/domain/entities/day.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:rxdart/rxdart.dart';

class DayRepository implements DayInterface {
  final BehaviorSubject<List<Day>> _days$ = BehaviorSubject();

  DayRepository({
    List<Day> days = const [],
  }) {
    _days$.add(days);
  }

  Stream<List<Day>> get _daysStream$ => _days$.stream;

  @override
  Stream<List<Day>> getUserDays({required String userId}) {
    return _daysStream$.map(
      (List<Day> days) => days
          .where(
            (Day day) => day.userId == userId,
          )
          .toList(),
    );
  }

  @override
  Future<void> initializeForUser({required String userId}) async {
    throw UnimplementedError();
    //TODO: implement this method
  }

  @override
  Future<void> loadUserDays({required String userId}) async {
    throw UnimplementedError();
    //TODO: implement this method
  }

  @override
  Future<void> addUserReadBook({
    required String userId,
    required String bookId,
    required int readPagesAmount,
  }) {
    throw UnimplementedError();
    //TODO: implement this method
  }

  @override
  void reset() {
    throw UnimplementedError();
    //TODO: implement this method
  }
}
