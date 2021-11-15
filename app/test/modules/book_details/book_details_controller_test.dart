import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/book_details/book_details_controller.dart';
import 'package:app/modules/book_details/book_details_dialogs.dart';
import 'package:app/modules/book_details/book_details_model.dart';
import 'package:app/modules/book_details/elements/book_details_action_sheet.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import '../global_mocks.dart';


class MockBookDetailsDialogs extends Mock implements BookDetailsDialogs {}

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  BookQuery bookQuery = MockBookQuery();
  BookCategoryService bookCategoryService = MockBookCategoryService();
  BookDetailsDialogs bookDetailsDialogs = MockBookDetailsDialogs();
  BookBloc bookBloc = MockBookBloc();
  ImagePicker imagePicker = MockImagePicker();
  late BookDetailsController controller;

  setUp(() {
    when(() => bookQuery.selectTitle('b1'))
        .thenAnswer((_) => new BehaviorSubject<String>.seeded('book title'));
    when(() => bookQuery.selectAuthor('b1'))
        .thenAnswer((_) => new BehaviorSubject<String>.seeded('author name'));
    when(() => bookQuery.selectCategory('b1')).thenAnswer((_) =>
        new BehaviorSubject<BookCategory>.seeded(
            BookCategory.biography_autobiography));
    when(() => bookQuery.selectImgUrl('b1'))
        .thenAnswer((_) => new BehaviorSubject<String>.seeded('img/url'));
    when(() => bookQuery.selectReadPages('b1'))
        .thenAnswer((_) => new BehaviorSubject<int>.seeded(100));
    when(() => bookQuery.selectPages('b1'))
        .thenAnswer((_) => new BehaviorSubject<int>.seeded(500));
    when(() => bookQuery.selectStatus('b1')).thenAnswer(
        (_) => new BehaviorSubject<BookStatus>.seeded(BookStatus.read));
    when(() => bookQuery.selectLastActualisationDate('b1'))
        .thenAnswer((_) => new BehaviorSubject<String>.seeded('05.10.2021'));
    when(() => bookQuery.selectAddDate('b1'))
        .thenAnswer((_) => new BehaviorSubject<String>.seeded('10.05.2021'));
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.biography_autobiography,
        )).thenReturn('biografie i autobiografie');
    controller = BookDetailsController(
      bookId: 'b1',
      bookQuery: bookQuery,
      bookCategoryService: bookCategoryService,
      bookDetailsDialogs: bookDetailsDialogs,
      bookBloc: bookBloc,
      imagePicker: imagePicker,
    );
  });

  tearDown(() {
    reset(bookQuery);
    reset(bookCategoryService);
    reset(bookDetailsDialogs);
    reset(bookBloc);
    reset(imagePicker);
  });

  group('book status', () {
    test('should be the status of selected book', () async {
      BookStatus status = await controller.bookStatus$.first;
      expect(status, BookStatus.read);
    });
  });

  group('book details', () {
    test('should contain all book details', () async {
      BookDetailsModel bookDetails = await controller.bookDetails$.first;
      expect(bookDetails.title, 'book title');
      expect(bookDetails.author, 'author name');
      expect(bookDetails.category, 'biografie i autobiografie');
      expect(bookDetails.imgUrl, 'img/url');
      expect(bookDetails.readPages, 100);
      expect(bookDetails.pages, 500);
      expect(bookDetails.status, 'W trakcie czytania');
      expect(bookDetails.lastActualisation, '05.10.2021');
      expect(bookDetails.addDate, '10.05.2021');
    });
  });

  group('on click function button', () {
    group('the book has read status', () {
      setUp(() async {
        await controller.onClickFunctionalButton();
      });

      test('should call update book details method with paused book status',
          () {
        verify(() => bookBloc.updateBook(
              bookId: 'b1',
              status: BookStatus.paused,
            )).called(1);
      });
    });

    group('the book has any other status except read status', () {
      late BookDetailsController newController;
      setUp(() async {
        when(() => bookQuery.selectStatus('b2')).thenAnswer(
            (_) => new BehaviorSubject<BookStatus>.seeded(BookStatus.pending));
        newController = BookDetailsController(
          bookId: 'b2',
          bookQuery: bookQuery,
          bookCategoryService: bookCategoryService,
          bookDetailsDialogs: bookDetailsDialogs,
          bookBloc: bookBloc,
          imagePicker: imagePicker,
        );
        await newController.onClickFunctionalButton();
      });

      test('should call update book details method with read book status', () {
        verify(() => bookBloc.updateBook(
              bookId: 'b2',
              status: BookStatus.read,
            )).called(1);
      });
    });
  });

  group('on click edit button', () {
    group('edit image', () {
      setUp(() {
        when(() => bookDetailsDialogs.askForEditOperation())
            .thenAnswer((_) async => BookDetailsEditAction.editImage);
      });

      group('image selected', () {
        setUp(() {
          when(() => imagePicker.pickImage(source: ImageSource.gallery))
              .thenAnswer((_) async => XFile('img/path'));
        });

        group('confirmed', () {
          setUp(() async {
            when(() => bookDetailsDialogs.askForNewImageConfirmation(
                  'img/path',
                )).thenAnswer((_) async => true);
            await controller.onClickEditButton();
          });

          test('should call update image method with new image path', () {
            verify(() => bookBloc.updateBookImg(
                  bookId: 'b1',
                  newImgPath: 'img/path',
                )).called(1);
          });
        });

        group('canceled', () {
          setUp(() async {
            when(() => bookDetailsDialogs.askForNewImageConfirmation(
                  'img/path',
                )).thenAnswer((_) async => false);
            await controller.onClickEditButton();
          });

          test('should not call update image method', () {
            verifyNever(() => bookBloc.updateBookImg(
                  bookId: 'b1',
                  newImgPath: 'img/path',
                ));
          });
        });
      });

      group('image not selected', () {
        setUp(() async {
          when(() => imagePicker.pickImage(source: ImageSource.gallery))
              .thenAnswer((_) async => null);
          await controller.onClickEditButton();
        });

        test('should not call update image method', () {
          verifyNever(() => bookBloc.updateBookImg(
                bookId: 'b1',
                newImgPath: 'img/path',
              ));
        });
      });
    });

    group('edit details', () {
      setUp(() {
        when(() => bookDetailsDialogs.askForEditOperation())
            .thenAnswer((_) async => BookDetailsEditAction.editDetails);
      });

      group('amount of read pages is higher than amount of all book pages', () {
        group('changed read pages', () {
          setUp(() {
            when(
              () =>
                  bookDetailsDialogs.askForNewBookDetails(BookDetailsEditModel(
                title: 'book title',
                author: 'author name',
                category: BookCategory.biography_autobiography,
                readPages: 100,
                pages: 500,
              )),
            ).thenAnswer(
                (_) async => BookDetailsEditedDataModel(readPages: 600));
          });

          group('confirmed', () {
            setUp(() async {
              when(() => bookDetailsDialogs.askForEndReadingBookConfirmation())
                  .thenAnswer((_) async => true);
              await controller.onClickEditButton();
            });

            test(
              'should call update book details method with new book details, end status and read pages number set to the total number of book pages',
              () {
                verify(() => bookBloc.updateBook(
                      bookId: 'b1',
                      author: null,
                      title: null,
                      category: null,
                      pages: null,
                      readPages: 500,
                      status: BookStatus.end,
                    )).called(1);
              },
            );
          });

          group('canceled', () {
            setUp(() async {
              when(() => bookDetailsDialogs.askForEndReadingBookConfirmation())
                  .thenAnswer((_) async => false);
              await controller.onClickEditButton();
            });

            test('should not call update book details method', () {
              verifyNever(() => bookBloc.updateBook(
                    bookId: 'b1',
                    author: null,
                    title: null,
                    category: null,
                    pages: null,
                    readPages: 500,
                    status: BookStatus.end,
                  ));
            });
          });
        });

        group('changed pages number', () {
          setUp(() async {
            when(
              () =>
                  bookDetailsDialogs.askForNewBookDetails(BookDetailsEditModel(
                title: 'book title',
                author: 'author name',
                category: BookCategory.biography_autobiography,
                readPages: 100,
                pages: 500,
              )),
            ).thenAnswer((_) async => BookDetailsEditedDataModel(pages: 50));
            when(() => bookDetailsDialogs.askForEndReadingBookConfirmation())
                .thenAnswer((_) async => true);
            await controller.onClickEditButton();
          });

          test(
            'should call update book details method with new book details, end status and read pages number set to the new total number of book pages',
            () {
              verify(() => bookBloc.updateBook(
                    bookId: 'b1',
                    author: null,
                    title: null,
                    category: null,
                    pages: 50,
                    readPages: 50,
                    status: BookStatus.end,
                  )).called(1);
            },
          );
        });
      });

      group('normal edit', () {
        setUp(() async {
          when(
            () => bookDetailsDialogs.askForNewBookDetails(BookDetailsEditModel(
              title: 'book title',
              author: 'author name',
              category: BookCategory.biography_autobiography,
              readPages: 100,
              pages: 500,
            )),
          ).thenAnswer((_) async => BookDetailsEditedDataModel(
                title: 'new title',
                category: BookCategory.academic_books,
                pages: 400,
              ));
          await controller.onClickEditButton();
        });

        test('should call update book details method with new details', () {
          verify(() => bookBloc.updateBook(
                bookId: 'b1',
                title: 'new title',
                author: null,
                category: BookCategory.academic_books,
                readPages: null,
                pages: 400,
                status: null,
              )).called(1);
        });
      });
    });
  });

  group('on click delete button', () {
    group('accepted', () {
      setUp(() async {
        when(() => bookDetailsDialogs.askForDeleteBookConfirmation(
              'book title',
            )).thenAnswer((_) async => true);
        await controller.onClickDeleteButton();
      });

      test('should call delete book method', () {
        verify(() => bookBloc.deleteBook(bookId: 'b1')).called(1);
      });
    });

    group('canceled', () {
      setUp(() async {
        when(() => bookDetailsDialogs.askForDeleteBookConfirmation(
              'book title',
            )).thenAnswer((_) async => false);
        await controller.onClickDeleteButton();
      });

      test('should not call delete book method', () {
        verifyNever(() => bookBloc.deleteBook(bookId: 'b1'));
      });
    });
  });
}
