import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/modules/home/bloc/home_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../global_mocks.dart';

void main() {
  BookQuery bookQuery = MockBookQuery();
  late HomeQuery query;
  const List<String> expectedBooksIds = ['b1', 'b2', 'b3'];

  setUp(() {
    query = HomeQuery(bookQuery: bookQuery);
    when(() => bookQuery.selectIdsByStatuses([BookStatus.read]))
        .thenAnswer((_) => Stream.value(expectedBooksIds));
  });

  tearDown(() {
    reset(bookQuery);
  });

  test('books ids', () async {
    List<String> booksIds = await query.booksIds$.first;

    expect(booksIds, expectedBooksIds);
  });

  test('books categories', () async {
    const List<BookCategory> expectedCategories = [
      BookCategory.art,
      BookCategory.academic_books,
      BookCategory.horror,
    ];
    when(() => bookQuery.selectCategory(expectedBooksIds[0]))
        .thenAnswer((_) => Stream.value(expectedCategories[0]));
    when(() => bookQuery.selectCategory(expectedBooksIds[1]))
        .thenAnswer((_) => Stream.value(expectedCategories[1]));
    when(() => bookQuery.selectCategory(expectedBooksIds[2]))
        .thenAnswer((_) => Stream.value(expectedCategories[2]));

    List<BookCategory> booksCategories = await query.booksCategories$.first;

    expect(booksCategories, expectedCategories);
  });

  test('read pages', () async {
    const int b1ReadPages = 50;
    const int b2ReadPages = 200;
    const int b3ReadPages = 10;
    when(() => bookQuery.selectReadPages(expectedBooksIds[0]))
        .thenAnswer((_) => Stream.value(b1ReadPages));
    when(() => bookQuery.selectReadPages(expectedBooksIds[1]))
        .thenAnswer((_) => Stream.value(b2ReadPages));
    when(() => bookQuery.selectReadPages(expectedBooksIds[2]))
        .thenAnswer((_) => Stream.value(b3ReadPages));

    int readPages = await query.readPages$.first;

    expect(readPages, b1ReadPages + b2ReadPages + b3ReadPages);
  });

  test('all pages', () async {
    const int b1AllPages = 250;
    const int b2AllPages = 400;
    const int b3AllPages = 800;
    when(() => bookQuery.selectPages(expectedBooksIds[0]))
        .thenAnswer((_) => Stream.value(b1AllPages));
    when(() => bookQuery.selectPages(expectedBooksIds[1]))
        .thenAnswer((_) => Stream.value(b2AllPages));
    when(() => bookQuery.selectPages(expectedBooksIds[2]))
        .thenAnswer((_) => Stream.value(b3AllPages));

    int readPages = await query.allPages$.first;

    expect(readPages, b1AllPages + b2AllPages + b3AllPages);
  });

  test('select book item details', () async {
    Book book = createBook(
      title: 'title',
      author: 'author',
      readPages: 50,
      pages: 200,
      imgUrl: 'img/url',
    );
    when(() => bookQuery.selectDetails('b1')).thenAnswer(
      (_) => Stream.value(book),
    );

    BookItemDetails details = await query.selectBookItemDetails('b1').first;

    expect(
      details,
      BookItemDetails(
        title: 'title',
        author: 'author',
        readPages: 50,
        pages: 200,
        imgUrl: 'img/url',
      ),
    );
  });
}
