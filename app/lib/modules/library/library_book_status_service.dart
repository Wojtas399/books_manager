import 'package:app/core/book/book_model.dart';

class LibraryBookStatusService {
  BookStatus convertBookStatusStringToEnum(String status) {
    switch (status) {
      case 'czytane':
        return BookStatus.read;
      case 'przeczytane':
        return BookStatus.end;
      case 'nieprzeczytane':
        return BookStatus.pending;
      case 'wstrzymane':
        return BookStatus.paused;
      default:
        return BookStatus.pending;
    }
  }

  String convertBookStatusEnumToString(BookStatus status) {
    switch (status) {
      case BookStatus.pending:
        return 'nieprzeczytane';
      case BookStatus.read:
        return 'czytane';
      case BookStatus.end:
        return 'przeczytane';
      case BookStatus.paused:
        return 'wstrzymane';
    }
  }
}
