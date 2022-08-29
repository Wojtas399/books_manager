import '../domain/entities/book.dart';

extension BookExtensions on Book {
  bool belongsTo(String userId) {
    return this.userId == userId;
  }
}
