import 'package:app/backend/day_service.dart';
import 'package:app/repositories/day_repository/day_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DayRepository implements DayInterface {
  late final DayService _dayService;

  DayRepository({required DayService dayService}) {
    _dayService = dayService;
  }

  @override
  Stream<QuerySnapshot>? subscribeDays() {
    return _dayService.subscribeDays();
  }

  @override
  addPages({
    required String dayId,
    required String bookId,
    required int pagesToAdd,
  }) async {
    try {
      await _dayService.addPages(
        dayId: dayId,
        bookId: bookId,
        pagesToAdd: pagesToAdd,
      );
    } catch (error) {
      throw error;
    }
  }

  @override
  deletePages({required String bookId, required int pagesToDelete}) async {
    try {
      await _dayService.deletePages(
        bookId: bookId,
        pagesToDelete: pagesToDelete,
      );
    } catch (error) {
      throw error;
    }
  }
}
