import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/date_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  List<Book> allBooks = [
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
  ];
  BookQuery query = BookQuery(
    allBooks: new BehaviorSubject<List<Book>>.seeded(allBooks).stream,
  );

  test('select details', () async {
    Book details = await query.selectDetails('b1').first;

    expect(details, allBooks[0]);
  });

  test('select author', () async {
    String author = await query.selectAuthor('b1').first;

    expect(author, 'Jan Nowak');
  });

  test('select title', () async {
    String title = await query.selectTitle('b1').first;

    expect(title, 'Book title');
  });

  test('select category', () async {
    BookCategory category = await query.selectCategory('b1').first;

    expect(category, BookCategory.art);
  });

  test('select pages', () async {
    int pages = await query.selectPages('b1').first;

    expect(pages, 400);
  });

  test('select read pages', () async {
    int readPages = await query.selectReadPages('b1').first;

    expect(readPages, 220);
  });

  test('select status', () async {
    BookStatus status = await query.selectStatus('b1').first;

    expect(status, BookStatus.read);
  });

  test('select img url', () async {
    String imgUrl = await query.selectImgUrl('b1').first;

    expect(imgUrl, 'img/url');
  });

  test('select last actualisation', () async {
    String lastActualisationDate =
        await query.selectLastActualisationDate('b1').first;

    expect(lastActualisationDate, '05.10.2021');
  });

  test('select add date', () async {
    String addDate = await query.selectAddDate('b1').first;

    expect(addDate, '21.09.2021');
  });

  test('select all ids', () async {
    List<String> booksIds = await query.selectAllIds().first;

    expect(booksIds, ['b1', 'b2']);
  });

  test('select ids by statuses', () async {
    List<String> booksIds =
        await query.selectIdsByStatuses([BookStatus.read]).first;

    expect(booksIds, ['b1']);
  });
}
