import 'package:app/domain/entities/day.dart';

abstract class DayInterface {
  Stream<List<Day>> getUserDays({required String userId});

  Future<void> initializeForUser({required String userId});

  Future<void> loadUserDays({required String userId});

  Future<void> addNewReadPages({
    required String userId,
    required DateTime date,
    required String bookId,
    required int amountOfReadPagesToAdd,
  });

  void reset();
}
