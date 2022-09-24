import 'package:app/domain/entities/day.dart';

abstract class DayInterface {
  Stream<List<Day>> getUserDays({required String userId});

  Future<void> addReadPagesForUser({
    required String userId,
    required String bookId,
    required int readPagesAmount,
  });
}
