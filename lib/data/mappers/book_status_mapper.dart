import 'package:app/domain/entities/book.dart';

class BookStatusMapper {
  static String mapFromEnumToString(BookStatus bookStatus) {
    return bookStatus.name;
  }

  static BookStatus mapFromStringToEnum(String str) {
    switch (str) {
      case 'unread':
        return BookStatus.unread;
      case 'inProgress':
        return BookStatus.inProgress;
      case 'finished':
        return BookStatus.finished;
      default:
        throw 'Cannot convert book status';
    }
  }
}
