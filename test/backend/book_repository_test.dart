import 'dart:async';
import 'package:app/backend/services/book_service.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/core/services/book_status_service.dart';
import 'package:app/backend/repositories/book_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

class MockBookService extends Mock implements BookService {}

class MockBookCategoryService extends Mock implements BookCategoryService {}

class MockBookStatusService extends Mock implements BookStatusService {}

void main() {
  BookService bookService = MockBookService();
  BookCategoryService bookCategoryService = MockBookCategoryService();
  BookStatusService bookStatusService = MockBookStatusService();
  late BookRepository repository;

  setUp(() {
    repository = BookRepository(
      bookService: bookService,
      bookCategoryService: bookCategoryService,
      bookStatusService: bookStatusService,
    );
  });

  tearDown(() {
    reset(bookService);
    reset(bookCategoryService);
    reset(bookStatusService);
  });

  test('subscribe books', () {
    BehaviorSubject<QuerySnapshot> snapshotController = BehaviorSubject();
    when(
      () => bookService.subscribeBooks(),
    ).thenAnswer((_) => snapshotController.stream);

    Stream<QuerySnapshot>? snapshot = repository.subscribeBooks();

    expect(snapshot, snapshotController.stream);
    snapshotController.close();
  });

  test('get img url, success', () async {
    when(() => bookService.getImgUrl('img/path'))
        .thenAnswer((_) async => 'img/url');

    String imgUrl = await repository.getImgUrl('img/path');

    expect(imgUrl, 'img/url');
  });

  test('get img url, failure', () async {
    when(() => bookService.getImgUrl('img/path')).thenThrow('Error...');

    try {
      await repository.getImgUrl('img/path');
    } catch (error) {
      expect(error, 'Error...');
    }
  });

  group('add new book, success', () {
    Book book = createBook(
      title: 'title is not important',
      author: 'Jack Novakowsky',
      category: BookCategory.art,
      imgPath: 'img/path',
      readPages: 0,
      pages: 100,
      status: BookStatus.read,
    );

    setUp(() {
      when(() => bookCategoryService.convertCategoryToText(book.category))
          .thenReturn('category');
      when(() => bookStatusService.convertBookStatusToString(book.status))
          .thenReturn('status');
    });

    test('success', () async {
      when(
        () => bookService.addBook(
          title: book.title,
          author: book.author,
          category: 'category',
          imgPath: book.imgPath,
          readPages: book.readPages,
          pages: book.pages,
          status: 'status',
        ),
      ).thenAnswer((_) async => 'success');

      await repository.addNewBook(
        title: book.title,
        author: book.author,
        category: book.category,
        imgPath: book.imgPath,
        readPages: book.readPages,
        pages: book.pages,
        status: book.status,
      );

      verify(
        () => bookService.addBook(
          title: book.title,
          author: book.author,
          category: 'category',
          imgPath: book.imgPath,
          readPages: book.readPages,
          pages: book.pages,
          status: 'status',
        ),
      ).called(1);
    });

    test('failure', () async {
      when(
        () => bookService.addBook(
          title: book.title,
          author: book.author,
          category: 'category',
          imgPath: book.imgPath,
          readPages: book.readPages,
          pages: book.pages,
          status: 'status',
        ),
      ).thenThrow('Error...');

      try {
        await repository.addNewBook(
          title: book.title,
          author: book.author,
          category: book.category,
          imgPath: book.imgPath,
          readPages: book.readPages,
          pages: book.pages,
          status: book.status,
        );
      } catch (error) {
        expect(error, 'Error...');
      }
    });
  });

  test('update book img, success', () async {
    when(
      () => bookService.updateBookImage(bookId: 'b1', newImgPath: 'img/path'),
    ).thenAnswer((_) async => 'Success');

    await repository.updateBookImage(bookId: 'b1', newImgPath: 'img/path');

    verify(
      () => bookService.updateBookImage(bookId: 'b1', newImgPath: 'img/path'),
    ).called(1);
  });

  test('update book img, failure', () async {
    when(
      () => bookService.updateBookImage(bookId: 'b1', newImgPath: 'img/path'),
    ).thenThrow('Error...');

    try {
      await repository.updateBookImage(
        bookId: 'b1',
        newImgPath: 'img/path',
      );
    } catch (error) {
      expect(error, 'Error...');
    }
  });

  test('update book, success', () async {
    when(() => bookService.updateBook(bookId: 'b1', title: 'New title'))
        .thenAnswer((_) async => 'Success');

    await repository.updateBook(bookId: 'b1', title: 'New title');

    verify(() => bookService.updateBook(bookId: 'b1', title: 'New title'))
        .called(1);
  });

  test('update book, failure', () async {
    when(() => bookService.updateBook(bookId: 'b1', title: 'New title'))
        .thenThrow('Error...');

    try {
      await repository.updateBook(bookId: 'b1', title: 'New title');
    } catch (error) {
      expect(error, 'Error...');
    }
  });

  test('delete book, success', () async {
    when(() => bookService.deleteBook(bookId: 'b1'))
        .thenAnswer((_) async => 'success');

    await repository.deleteBook(bookId: 'b1');

    verify(() => bookService.deleteBook(bookId: 'b1')).called(1);
  });

  test('delete book, failure', () async {
    when(() => bookService.deleteBook(bookId: 'b1')).thenThrow('Error...');

    try {
      await repository.deleteBook(bookId: 'b1');
    } catch (error) {
      expect(error, 'Error...');
    }
  });
}
