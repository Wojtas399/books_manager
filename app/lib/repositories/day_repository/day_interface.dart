import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DayInterface {
  Stream<QuerySnapshot>? subscribeDays();

  addPages({
    required String dayId,
    required String bookId,
    required int pagesToAdd,
  });

  deletePages({
    required String bookId,
    required int pagesToDelete,
  });
}
