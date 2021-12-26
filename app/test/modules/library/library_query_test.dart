import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/modules/library/bloc/library_query.dart';
import 'package:app/modules/library/library_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../global_mocks.dart';

void main() {
  BookQuery bookQuery = MockBookQuery();
  late LibraryQuery query;
  List<BookInfo> fakeBooksInfo = [
    BookInfo(
      id: 'b1',
      title: 'title first',
      author: 'first author',
      status: BookStatus.read,
      category: BookCategory.for_kids,
      pages: 500,
    ),
    BookInfo(
      id: 'b2',
      title: 'title second',
      author: 'second author',
      status: BookStatus.end,
      category: BookCategory.art,
      pages: 250,
    ),
  ];

  setUp(() {
    when(() => bookQuery.selectAllIds()).thenAnswer((_) => Stream.value([
          fakeBooksInfo[0].id,
          fakeBooksInfo[1].id,
        ]));
    when(() => bookQuery.selectTitle(fakeBooksInfo[0].id))
        .thenAnswer((_) => Stream.value(fakeBooksInfo[0].title));
    when(() => bookQuery.selectAuthor(fakeBooksInfo[0].id))
        .thenAnswer((_) => Stream.value(fakeBooksInfo[0].author));
    when(() => bookQuery.selectStatus(fakeBooksInfo[0].id))
        .thenAnswer((_) => Stream.value(fakeBooksInfo[0].status));
    when(() => bookQuery.selectCategory(fakeBooksInfo[0].id))
        .thenAnswer((_) => Stream.value(fakeBooksInfo[0].category));
    when(() => bookQuery.selectPages(fakeBooksInfo[0].id))
        .thenAnswer((_) => Stream.value(fakeBooksInfo[0].pages));
    when(() => bookQuery.selectTitle(fakeBooksInfo[1].id))
        .thenAnswer((_) => Stream.value(fakeBooksInfo[1].title));
    when(() => bookQuery.selectAuthor(fakeBooksInfo[1].id))
        .thenAnswer((_) => Stream.value(fakeBooksInfo[1].author));
    when(() => bookQuery.selectStatus(fakeBooksInfo[1].id))
        .thenAnswer((_) => Stream.value(fakeBooksInfo[1].status));
    when(() => bookQuery.selectCategory(fakeBooksInfo[1].id))
        .thenAnswer((_) => Stream.value(fakeBooksInfo[1].category));
    when(() => bookQuery.selectPages(fakeBooksInfo[1].id))
        .thenAnswer((_) => Stream.value(fakeBooksInfo[1].pages));

    query = LibraryQuery(bookQuery: bookQuery);
  });

  tearDown(() {
    reset(bookQuery);
  });

  test('all books info', () async {
    List<BookInfo> allBooksInfo = await query.allBooksInfo$.first;

    expect(allBooksInfo, fakeBooksInfo);
  });
}
