import 'package:app/domain/entities/book.dart';

extension BookExtension on Book {
  bool belongsTo(String userId) {
    return this.userId == userId;
  }
}
