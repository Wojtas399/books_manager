import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/repositories/book_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  BookInterface bookInterface = MockBookInterface();
  late BookBloc bookBloc;

  setUp(() => bookBloc = BookBloc(bookInterface: bookInterface));

  tearDown(() => reset(bookInterface));

  group('getImgUrl', () {
    setUp(() {
      when(() => bookInterface.getImgUrl('img/path'))
          .thenAnswer((_) async => 'img/url');
    });

    test('Should return the image url', () async {
      String imgUrl = await bookBloc.getImgUrl('img/path');
      expect(imgUrl, 'img/url');
    });
  });

  group('addNewBook', () {
    setUp(() async {
      await bookBloc.addNewBook(
        title: 'title',
        author: 'author',
        category: BookCategory.biography_autobiography,
        imgPath: 'imgPath',
        readPages: 0,
        pages: 100,
        status: BookStatus.pending,
      );
    });

    test('should call add new book method from book repo', () {
      verify(() => bookInterface.addNewBook(
            title: 'title',
            author: 'author',
            category: BookCategory.biography_autobiography,
            imgPath: 'imgPath',
            readPages: 0,
            pages: 100,
            status: BookStatus.pending,
          )).called(1);
    });
  });

  group('updateBookImage', () {
    setUp(() async {
      await bookBloc.updateBookImg(bookId: 'b1', newImgPath: 'newImgPath');
    });

    test('should call update book image method from book repo', () {
      verify(() => bookInterface.updateBookImage(
            bookId: 'b1',
            newImgPath: 'newImgPath',
          )).called(1);
    });
  });

  group('updateBook', () {
    setUp(() async {
      await bookBloc.updateBook(
        bookId: 'b1',
        readPages: 200,
        status: BookStatus.end,
      );
    });

    test('should call update book method from book repo', () {
      verify(() => bookInterface.updateBook(
            bookId: 'b1',
            readPages: 200,
            status: BookStatus.end,
          )).called(1);
    });
  });
}
