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

  group('subscribeBooks', () {
    BehaviorSubject<QuerySnapshot> controller = BehaviorSubject();
    setUp(() {
      when(() => bookService.subscribeBooks())
          .thenAnswer((_) => controller.stream);
    });
    tearDown(() => controller.close());

    test('Should return snapshot', () {
      Stream<QuerySnapshot>? snapshot = repository.subscribeBooks();
      expect(snapshot, controller.stream);
    });
  });

  group('getImgUrl', () {
    group('success', () {
      setUp(() {
        when(() => bookService.getImgUrl('img/path'))
            .thenAnswer((_) async => 'img/url');
      });

      test('Should return img url', () async {
        String imgUrl = await repository.getImgUrl('img/path');
        expect(imgUrl, 'img/url');
      });
    });

    group('failure', () {
      setUp(() {
        when(() => bookService.getImgUrl('img/path')).thenThrow('Error...');
      });

      test('Should throw error', () async {
        try {
          await repository.getImgUrl('img/path');
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });

  group('addNewBook', () {
    setUp(() {
      when(() => bookCategoryService.convertCategoryToText(BookCategory.art))
          .thenReturn('category');
      when(() => bookStatusService.convertBookStatusToString(BookStatus.read))
          .thenReturn('status');
    });

    group('success', () {
      setUp(() async {
        when(
          () => bookService.addBook(
            title: 'title',
            author: 'author',
            category: 'category',
            imgPath: 'imgPath',
            readPages: 0,
            pages: 100,
            status: 'status',
          ),
        ).thenAnswer((_) async => 'success');
        await repository.addNewBook(
          title: 'title',
          author: 'author',
          category: BookCategory.art,
          imgPath: 'imgPath',
          readPages: 0,
          pages: 100,
          status: BookStatus.read,
        );
      });

      test('should call add new book method with book details', () {
        verify(() => bookService.addBook(
              title: 'title',
              author: 'author',
              category: 'category',
              imgPath: 'imgPath',
              readPages: 0,
              pages: 100,
              status: 'status',
            )).called(1);
      });
    });

    group('failure', () {
      setUp(() {
        when(
          () => bookService.addBook(
            title: 'title',
            author: 'author',
            category: 'category',
            imgPath: 'imgPath',
            readPages: 0,
            pages: 100,
            status: 'status',
          ),
        ).thenThrow('Error...');
      });

      test('should throw error', () async {
        try {
          await repository.addNewBook(
            title: 'title',
            author: 'author',
            category: BookCategory.art,
            imgPath: 'imgPath',
            readPages: 0,
            pages: 100,
            status: BookStatus.read,
          );
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });

  group('updateBookImg', () {
    group('success', () {
      setUp(() async {
        when(() => bookService.updateBookImage(
              bookId: 'b1',
              newImgPath: 'img/path',
            )).thenAnswer((_) async => 'Success');
        await repository.updateBookImage(bookId: 'b1', newImgPath: 'img/path');
      });

      test('Should call update image method', () {
        verify(() => bookService.updateBookImage(
              bookId: 'b1',
              newImgPath: 'img/path',
            )).called(1);
      });
    });

    group('failure', () {
      setUp(() {
        when(() => bookService.updateBookImage(
              bookId: 'b1',
              newImgPath: 'img/path',
            )).thenThrow('Error...');
      });

      test('Should throw error', () async {
        try {
          await repository.updateBookImage(
            bookId: 'b1',
            newImgPath: 'img/path',
          );
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });

  group('updateBook', () {
    group('success', () {
      setUp(() async {
        when(() => bookService.updateBook(bookId: 'b1', title: 'New title'))
            .thenAnswer((_) async => 'Success');
        await repository.updateBook(bookId: 'b1', title: 'New title');
      });

      test('Should call update book method', () {
        verify(() => bookService.updateBook(
              bookId: 'b1',
              title: 'New title',
            )).called(1);
      });
    });

    group('failure', () {
      setUp(() async {
        when(() => bookService.updateBook(bookId: 'b1', title: 'New title'))
            .thenThrow('Error...');
      });

      test('Should throw error', () async {
        try {
          await repository.updateBook(bookId: 'b1', title: 'New title');
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });

  group('deleteBook', () {
    group('success', () {
      setUp(() async {
        when(() => bookService.deleteBook(bookId: 'b1'))
            .thenAnswer((_) async => 'success');
        await repository.deleteBook(bookId: 'b1');
      });

      test('Should call delete book method', () {
        verify(() => bookService.deleteBook(bookId: 'b1')).called(1);
      });
    });

    group('failure', () {
      setUp(() {
        when(() => bookService.deleteBook(bookId: 'b1')).thenThrow('Error...');
      });

      test('Should throw error', () async {
        try {
          await repository.deleteBook(bookId: 'b1');
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });
}
