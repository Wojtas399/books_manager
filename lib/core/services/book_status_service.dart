import 'package:app/core/book/book_model.dart';

class BookStatusService {
  BookStatus convertStringToBookStatus(String status) {
    switch (status) {
      case 'free':
        return BookStatus.pending;
      case 'read':
        return BookStatus.read;
      case 'endRead':
        return BookStatus.end;
      case 'paused':
        return BookStatus.paused;
      default:
        return BookStatus.pending;
    }
  }

  String convertBookStatusToString(BookStatus status) {
    switch (status) {
      case BookStatus.read:
        return 'read';
      case BookStatus.pending:
        return 'free';
      case BookStatus.end:
        return 'endRead';
      case BookStatus.paused:
        return 'paused';
    }
  }
}