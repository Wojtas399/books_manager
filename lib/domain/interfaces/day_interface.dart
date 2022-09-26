import 'package:app/domain/entities/day.dart';

abstract class DayInterface {
  Stream<List<Day>> getUserDays({required String userId});

  Future<void> initializeForUser({required String userId});

  Future<void> loadUserDays({required String userId});

  Future<void> addUserReadBook({
    required String userId,
    required String bookId,
    required int readPagesAmount,
  });

  void reset();
}
