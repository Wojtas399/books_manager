import 'package:app/data/data_sources/day_data_source.dart';
import 'package:app/domain/entities/day.dart';
import 'package:app/domain/interfaces/day_interface.dart';

class DayRepository implements DayInterface {
  late final DayDataSource _dayDataSource;

  DayRepository({required DayDataSource dayDataSource}) {
    _dayDataSource = dayDataSource;
  }

  @override
  Stream<List<Day>> getUserDays({required String userId}) {
    return _dayDataSource.getUserDays(userId: userId);
  }

  @override
  Stream<List<Day>> getUserDaysFromMonth({
    required String userId,
    required int month,
    required int year,
  }) {
    return _dayDataSource.getUserDaysFromMonth(
      userId: userId,
      month: month,
      year: year,
    );
  }

  @override
  Future<void> addNewDay({required Day day}) async {
    await _dayDataSource.addDay(day: day);
  }

  @override
  Future<void> updateDay({required Day updatedDay}) async {
    await _dayDataSource.updateDay(updatedDay: updatedDay);
  }

  @override
  Future<void> deleteDay({
    required String userId,
    required DateTime date,
  }) async {
    await _dayDataSource.deleteDay(userId: userId, date: date);
  }
}
