import 'package:app/domain/entities/day.dart';

abstract class DayInterface {
  Stream<List<Day>?> getUserDays({required String userId});

  Future<void> initializeForUser({required String userId});

  Future<void> loadUserDaysFromMonth({
    required String userId,
    required int month,
    required int year,
  });

  Future<void> addNewDay({required Day day});

  Future<void> updateDay({required Day updatedDay});

  Future<void> deleteDay({
    required String userId,
    required DateTime date,
  });
}
