import 'package:app/domain/entities/book.dart';
import 'package:app/extensions/book_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'belongs to, should return true if book user id matches given user id',
    () {
      const String userId = 'u1';
      final Book book = createBook(userId: 'u1');
      const bool expectedValue = true;

      final bool doesBookBelongToUser = book.belongsTo(userId);

      expect(doesBookBelongToUser, expectedValue);
    },
  );

  test(
    'belongs to, should return false if book user id does not match given user id',
    () {
      const String userId = 'u2';
      final Book book = createBook(userId: 'u1');
      const bool expectedValue = false;

      final bool doesBookBelongToUser = book.belongsTo(userId);

      expect(doesBookBelongToUser, expectedValue);
    },
  );
}
