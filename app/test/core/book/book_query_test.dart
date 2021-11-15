import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/date_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  BehaviorSubject<List<Book>> allBooks = BehaviorSubject();
  BookQuery query = BookQuery(allBooks: allBooks.stream);

  setUpAll(() {
    allBooks.add([
      createBook(
        id: 'b1',
        author: 'Jan Nowak',
        title: 'Book title',
        category: BookCategory.art,
        pages: 400,
        readPages: 220,
        imgUrl: 'img/url',
        status: BookStatus.read,
        lastActualisation: '05.10.2021',
        addDate: '21.09.2021',
      ),
      createBook(
        id: 'b2',
        status: BookStatus.paused,
        addDate: DateService.getCurrentDate(),
      ),
    ]);
  });

  tearDownAll(() => allBooks.close());

  group('selectAuthor', () {
    test('Should be the author of selected book', () async {
      String author = await query.selectAuthor('b1').first;
      expect(author, 'Jan Nowak');
    });
  });

  group('selectTitle', () {
    test('Should be the title of selected book', () async {
      String title = await query.selectTitle('b1').first;
      expect(title, 'Book title');
    });
  });

  group('selectCategory', () {
    test('Should be the category of selected book', () async {
      BookCategory category = await query.selectCategory('b1').first;
      expect(category, BookCategory.art);
    });
  });

  group('selectPages', () {
    test('Should be the pages of selected book', () async {
      int pages = await query.selectPages('b1').first;
      expect(pages, 400);
    });
  });

  group('selectReadPages', () {
    test('Should be the read pages of selected book', () async {
      int readPages = await query.selectReadPages('b1').first;
      expect(readPages, 220);
    });
  });

  group('selectStatus', () {
    test('Should be the status of selected book', () async {
      BookStatus status = await query.selectStatus('b1').first;
      expect(status, BookStatus.read);
    });
  });

  group('selectImgUrl', () {
    test('Should be the imgUrl of selected book', () async {
      String imgUrl = await query.selectImgUrl('b1').first;
      expect(imgUrl, 'img/url');
    });
  });

  group('selectLastActualisation', () {
    test('Should be tha last actualisation date of selected book', () async {
      String lastActualisationDate = await query.selectLastActualisationDate('b1').first;
      expect(lastActualisationDate, '05.10.2021');
    });
  });

  group('addDate', () {
    test('Should be the date when the book was added', () async {
      String addDate = await query.selectAddDate('b1').first;
      expect(addDate, '21.09.2021');
    });
  });

  group('selectAllIds', () {
    test('Should contain ids of all books', () async {
      List<String> booksIds = await query.selectAllIds().first;
      expect(booksIds, ['b1', 'b2']);
    });
  });

  group('selectIdsByStatuses', () {
    test('Should contain books ids of selected status', () async {
      List<String> booksIds =
          await query.selectIdsByStatuses([BookStatus.read]).first;
      expect(booksIds, ['b1']);
    });
  });

  group('selectNewBooksIds', () {
    test('Should contain new books ids', () async {
      List<String> booksIds = await query.selectNewBooksIds().first;
      expect(booksIds, ['b2']);
    });
  });
}
