import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/interfaces/book_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  BookInterface bookInterface = MockBookInterface();
  late BookBloc bookBloc;

  setUp(() {
    bookBloc = BookBloc(bookInterface: bookInterface);
  });

  tearDown(() {
    reset(bookInterface);
  });

  test('get img url', () async {
    when(() => bookInterface.getImgUrl('img/path'))
        .thenAnswer((_) async => 'img/url');

    String imgUrl = await bookBloc.getImgUrl('img/path');

    expect(imgUrl, 'img/url');
  });

  test('add new book', () async {
    await bookBloc.addNewBook(
      title: 'title',
      author: 'author',
      category: BookCategory.biography_autobiography,
      imgPath: 'imgPath',
      readPages: 0,
      pages: 100,
      status: BookStatus.pending,
    );

    verify(
      () => bookInterface.addNewBook(
        title: 'title',
        author: 'author',
        category: BookCategory.biography_autobiography,
        imgPath: 'imgPath',
        readPages: 0,
        pages: 100,
        status: BookStatus.pending,
      ),
    ).called(1);
  });

  test('update book image', () async {
    await bookBloc.updateBookImg(bookId: 'b1', newImgPath: 'newImgPath');

    verify(
      () => bookInterface.updateBookImage(
        bookId: 'b1',
        newImgPath: 'newImgPath',
      ),
    ).called(1);
  });

  test('update book', () async {
    await bookBloc.updateBook(
      bookId: 'b1',
      readPages: 200,
      status: BookStatus.end,
    );

    verify(
      () => bookInterface.updateBook(
        bookId: 'b1',
        readPages: 200,
        status: BookStatus.end,
      ),
    ).called(1);
  });

  test('delete book', () async {
    await bookBloc.deleteBook(bookId: 'b1');

    verify(() => bookInterface.deleteBook(bookId: 'b1')).called(1);
  });
}
