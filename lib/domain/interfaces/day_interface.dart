import 'package:app/domain/entities/day.dart';
import 'package:app/domain/entities/read_book.dart';

abstract class DayInterface {
  Stream<List<Day>> getUserDays({required String userId});

  Future<void> initializeForUser({required String userId});

  Future<void> loadUserDays({required String userId});

  Future<void> addUserReadBook({
    required ReadBook readBook,
    required String userId,
    required DateTime date,
  });

  Future<void> updateReadPagesAmountOfUserReadBook({
    required String userId,
    required DateTime date,
    required String bookId,
    required int updatedReadPagesAmount,
  });

  void reset();
}
