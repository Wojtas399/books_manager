import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/domain/entities/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map from enum to string, unread',
    () {
      const BookStatus bookStatus = BookStatus.unread;
      const String expectedString = 'unread';

      final String str = BookStatusMapper.mapFromEnumToString(bookStatus);

      expect(str, expectedString);
    },
  );

  test(
    'map from enum to string, in progress',
    () {
      const BookStatus bookStatus = BookStatus.inProgress;
      const String expectedString = 'inProgress';

      final String str = BookStatusMapper.mapFromEnumToString(bookStatus);

      expect(str, expectedString);
    },
  );

  test(
    'map from enum to string, finished',
    () {
      const BookStatus bookStatus = BookStatus.finished;
      const String expectedString = 'finished';

      final String str = BookStatusMapper.mapFromEnumToString(bookStatus);

      expect(str, expectedString);
    },
  );

  test(
    'map from string to enum, unread',
    () {
      const String str = 'unread';
      const BookStatus expectedBookStatus = BookStatus.unread;

      final BookStatus bookStatus = BookStatusMapper.mapFromStringToEnum(str);

      expect(bookStatus, expectedBookStatus);
    },
  );

  test(
    'map from string to enum, in progress',
    () {
      const String str = 'inProgress';
      const BookStatus expectedBookStatus = BookStatus.inProgress;

      final BookStatus bookStatus = BookStatusMapper.mapFromStringToEnum(str);

      expect(bookStatus, expectedBookStatus);
    },
  );

  test(
    'map from string to enum, unread',
    () {
      const String str = 'finished';
      const BookStatus expectedBookStatus = BookStatus.finished;

      final BookStatus bookStatus = BookStatusMapper.mapFromStringToEnum(str);

      expect(bookStatus, expectedBookStatus);
    },
  );
}
