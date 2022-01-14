import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/book_details/bloc/book_details_query.dart';
import 'package:app/modules/book_details/book_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../global_mocks.dart';

void main() {
  const String bookId = 'b1';
  final BookQuery bookQuery = MockBookQuery();
  final BookCategoryService bookCategoryService = MockBookCategoryService();
  late BookDetailsQuery query;

  final bookDetails = createBook(
    author: 'author',
    title: 'book title',
    category: BookCategory.art,
    status: BookStatus.read,
    imgUrl: 'url/to/img',
    readPages: 100,
    pages: 700,
    lastActualisation: '14.01.2022',
    addDate: '01.12.2021',
  );

  setUp(() {
    query = BookDetailsQuery(
      bookId: bookId,
      bookQuery: bookQuery,
      bookCategoryService: bookCategoryService,
    );

    when(() => bookQuery.selectAuthor(bookId)).thenAnswer(
      (_) => Stream.value(bookDetails.title),
    );
    when(() => bookQuery.selectTitle(bookId)).thenAnswer(
      (_) => Stream.value(bookDetails.author),
    );
    when(() => bookQuery.selectCategory(bookId)).thenAnswer(
      (_) => Stream.value(bookDetails.category),
    );
    when(() => bookQuery.selectStatus(bookId)).thenAnswer(
      (_) => Stream.value(bookDetails.status),
    );
    when(() => bookQuery.selectImgUrl(bookId)).thenAnswer(
      (_) => Stream.value(bookDetails.imgUrl),
    );
    when(() => bookQuery.selectReadPages(bookId)).thenAnswer(
      (_) => Stream.value(bookDetails.readPages),
    );
    when(() => bookQuery.selectPages(bookId)).thenAnswer(
      (_) => Stream.value(bookDetails.pages),
    );
    when(() => bookQuery.selectLastActualisationDate(bookId)).thenAnswer(
      (_) => Stream.value(bookDetails.lastActualisation),
    );
    when(() => bookQuery.selectAddDate(bookId)).thenAnswer(
      (_) => Stream.value(bookDetails.addDate),
    );
  });

  tearDown(() {
    reset(bookQuery);
    reset(bookQuery);
    reset(bookCategoryService);
  });

  test('title', () async {
    final String title = await query.title$.first;

    expect(title, bookDetails.title);
  });

  test('category', () async {
    final BookCategory category = await query.category$.first;

    expect(category, bookDetails.category);
  });

  test('status', () async {
    final BookStatus bookStatus = await query.status$.first;

    expect(bookStatus, bookDetails.status);
  });

  test('book details', () async {
    final BookDetailsModel bookDetails = await query.bookDetails$.first;

    expect(
      bookDetails,
      BookDetailsModel(
        title: bookDetails.title,
        author: bookDetails.author,
        category: bookDetails.category,
        imgUrl: bookDetails.imgUrl,
        readPages: bookDetails.readPages,
        pages: bookDetails.pages,
        status: bookDetails.status,
        lastActualisation: bookDetails.lastActualisation,
        addDate: bookDetails.addDate,
      ),
    );
  });
}
