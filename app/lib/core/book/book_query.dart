import 'package:app/core/book/book_model.dart';

class BookQuery {
  Stream<List<Book>> allBooks;

  BookQuery({required this.allBooks});

  Stream<Book> selectDetails(String bookId) {
    return allBooks.map(
      (allBooks) => allBooks.firstWhere((book) => book.id == bookId),
    );
  }

  Stream<String> selectAuthor(String bookId) {
    return allBooks.map((allBooks) {
      int idx = allBooks.indexWhere((book) => book.id == bookId);
      return allBooks[idx].author;
    });
  }

  Stream<String> selectTitle(String bookId) {
    return allBooks.map((allBooks) {
      int idx = allBooks.indexWhere((book) => book.id == bookId);
      return allBooks[idx].title;
    });
  }

  Stream<BookCategory> selectCategory(String bookId) {
    return allBooks.map((allBooks) {
      int idx = allBooks.indexWhere((book) => book.id == bookId);
      return allBooks[idx].category;
    });
  }

  Stream<int> selectPages(String bookId) {
    return allBooks.map((allBooks) {
      int idx = allBooks.indexWhere((book) => book.id == bookId);
      return allBooks[idx].pages;
    });
  }

  Stream<int> selectReadPages(String bookId) {
    return allBooks.map((allBooks) {
      int idx = allBooks.indexWhere((book) => book.id == bookId);
      return allBooks[idx].readPages;
    });
  }

  Stream<BookStatus> selectStatus(String bookId) {
    return allBooks.map((allBooks) {
      int idx = allBooks.indexWhere((book) => book.id == bookId);
      return allBooks[idx].status;
    });
  }

  Stream<String> selectImgUrl(String bookId) {
    return allBooks.map((allBooks) {
      int idx = allBooks.indexWhere((book) => book.id == bookId);
      return allBooks[idx].imgUrl;
    });
  }

  Stream<String> selectLastActualisationDate(String bookId) {
    return allBooks.map((allBooks) {
      int idx = allBooks.indexWhere((book) => book.id == bookId);
      return allBooks[idx].lastActualisation;
    });
  }

  Stream<String> selectAddDate(String bookId) {
    return allBooks.map((allBooks) {
      int idx = allBooks.indexWhere((book) => book.id == bookId);
      return allBooks[idx].addDate;
    });
  }

  Stream<List<String>> selectAllIds() {
    return allBooks.map((allBooks) => allBooks.map((book) => book.id).toList());
  }

  Stream<List<String>> selectIdsByStatuses(List<BookStatus> statuses) {
    return allBooks.map(
      (allBooks) => allBooks
          .where((book) => statuses.contains(book.status))
          .map((book) => book.id)
          .toList(),
    );
  }
}
