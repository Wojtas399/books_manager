import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/core/services/image_service.dart';
import 'package:app/modules/add_book/add_book_controller.dart';
import 'package:app/modules/add_book/add_book_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../global_mocks.dart';

class MockImageService extends Mock implements ImageService {}

class MockBookCategoryService extends Mock implements BookCategoryService {}

void main() {
  ImageService imageService = MockImageService();
  BookCategoryService bookCategoryService = MockBookCategoryService();
  BookBloc bookBloc = MockBookBloc();
  late AddBookController controller;

  setUp(() {
    controller = AddBookController(
      imageService: imageService,
      bookCategoryService: bookCategoryService,
      bookBloc: bookBloc,
    );
  });

  tearDown(() {
    reset(imageService);
    reset(bookCategoryService);
    reset(bookBloc);
  });

  group('default state', () {
    group('title controller', () {
      test('should be set to empty string', () {
        expect(controller.titleController.text, '');
      });
    });

    group('author controller', () {
      test('should be set to empty string', () {
        expect(controller.authorController.text, '');
      });
    });

    group('readPages controller', () {
      test('should be set to empty string', () {
        expect(controller.readPagesController.text, '');
      });
    });

    group('pages controller', () {
      test('should be set to empty string', () {
        expect(controller.pagesController.text, '');
      });
    });

    group('img path', () {
      test('should be null', () {
        expect(controller.imgPath.value, null);
      });
    });

    group('book details', () {
      test('should contain default book details', () {
        AddBookFormModel details = controller.bookDetails.value;
        expect(details.title, '');
        expect(details.author, '');
        expect(details.category, 'biografie i autobiografie');
        expect(details.readPages, 0);
        expect(details.pages, 0);
      });
    });

    group('global form error message', () {
      test('should be empty string', () {
        expect(controller.globalFormErrorMessage.value, '');
      });
    });

    group('is next button disabled', () {
      test('should be true', () {
        expect(controller.isNextButtonDisabled.value, true);
      });
    });

    group('is save button disabled', () {
      test('should be true', () {
        expect(controller.isSaveButtonDisabled.value, true);
      });
    });
  });

  group('on click image button', () {
    setUp(() async {
      when(() => imageService.getImageFromGallery())
          .thenAnswer((_) async => 'img/path/picture.jpg');
      await controller.onClickImageButton();
    });

    test('should update img path value', () {
      expect(controller.imgPath.value, 'img/path/picture.jpg');
    });
  });

  group('buttons', () {
    setUp(() {
      controller.readPagesController.text = '0';
      controller.pagesController.text = '100';
    });

    group('next button', () {
      group('all details are entered', () {
        setUp(() {
          controller.bookDetails.value = AddBookFormModel(
            title: 'title',
            author: 'author',
            category: 'category',
            readPages: 0,
            pages: 100,
          );
        });

        test('should be false', () {
          expect(controller.isNextButtonDisabled.value, false);
        });
      });

      group('some details are missed', () {
        setUp(() {
          controller.bookDetails.value = AddBookFormModel(
            title: '',
            author: 'author',
            category: 'category',
            readPages: 0,
            pages: 100,
          );
        });

        test('should be true', () {
          expect(controller.isNextButtonDisabled.value, true);
        });
      });
    });

    group('save button', () {
      group('all details and image are entered', () {
        setUp(() {
          controller.imgPath.value = 'img/path';
          controller.bookDetails.value = AddBookFormModel(
            title: 'title',
            author: 'author',
            category: 'category',
            readPages: 0,
            pages: 100,
          );
        });

        test('should be false', () {
          expect(controller.isSaveButtonDisabled.value, false);
        });
      });

      group('image is missed', () {
        setUp(() {
          controller.imgPath.value = null;
          controller.bookDetails.value = AddBookFormModel(
            title: 'title',
            author: 'author',
            category: 'category',
            readPages: 0,
            pages: 100,
          );
        });

        test('should be true', () {
          expect(controller.isSaveButtonDisabled.value, true);
        });
      });

      group('some details are missed', () {
        setUp(() {
          controller.imgPath.value = 'img/path';
          controller.bookDetails.value = AddBookFormModel(
            title: 'title',
            author: '',
            category: 'category',
            readPages: 0,
            pages: 100,
          );
        });

        test('should be true', () {
          expect(controller.isSaveButtonDisabled.value, true);
        });
      });
    });
  });

  group('on title changed', () {
    setUp(() {
      controller.onTitleChanged('title');
    });

    test('should assign new title to the book details', () {
      expect(controller.bookDetails.value.title, 'title');
    });
  });

  group('on author changed', () {
    setUp(() {
      controller.onAuthorChanged('author');
    });

    test('should assign new author to the book details', () {
      expect(controller.bookDetails.value.author, 'author');
    });
  });

  group('on category changed', () {
    setUp(() {
      when(() => bookCategoryService.convertCategoryToText(BookCategory.art))
          .thenReturn('sztuka');
      controller.onCategoryChanged(BookCategory.art);
    });

    test('should assign new converted category to the book details', () {
      expect(controller.bookDetails.value.category, 'sztuka');
    });
  });

  group('on read pages number changed', () {
    group('string contains only numbers', () {
      setUp(() {
        controller.onReadPagesNumberChanged('20');
      });

      test('should assign converted read pages number to the book details', () {
        expect(controller.bookDetails.value.readPages, 20);
      });
    });

    group('string contains not only numbers', () {
      setUp(() {
        controller.onReadPagesNumberChanged('22asda');
      });

      test('should assign number 0 to the book details', () {
        expect(controller.bookDetails.value.readPages, 0);
      });
    });

    group('the number in string is lower than zero', () {
      setUp(() {
        controller.onReadPagesNumberChanged('-10');
      });

      test('should assign number 0 to the book details', () {
        expect(controller.bookDetails.value.readPages, 0);
      });
    });
  });

  group('on pages number changed', () {
    group('string contains only numbers', () {
      setUp(() {
        controller.onPagesNumberChanged('20');
      });

      test('should assign converted pages number to the book details', () {
        expect(controller.bookDetails.value.pages, 20);
      });
    });

    group('string contains not only numbers', () {
      setUp(() {
        controller.onPagesNumberChanged('22asda');
      });

      test('should assign number 0 to the book details', () {
        expect(controller.bookDetails.value.pages, 0);
      });
    });

    group('the number in string is lower than zero', () {
      setUp(() {
        controller.onPagesNumberChanged('-10');
      });

      test('should assign number 0 to the book details', () {
        expect(controller.bookDetails.value.pages, 0);
      });
    });
  });

  group('on click add book button', () {
    setUp(() async {
      controller.imgPath.value = 'img/path/image.jpg';
      controller.bookDetails.value = AddBookFormModel(
        title: 'title',
        author: 'author',
        category: 'category',
        readPages: 0,
        pages: 200,
      );
      when(() => bookCategoryService.convertTextToCategory('category'))
          .thenReturn(BookCategory.art);
      await controller.onClickAddBookButton();
    });

    test('should call add ne book method from interface', () {
      verify(() => bookBloc.addNewBook(
            title: 'title',
            author: 'author',
            category: BookCategory.art,
            imgPath: 'img/path/image.jpg',
            readPages: 0,
            pages: 200,
            status: BookStatus.pending,
          )).called(1);
    });
  });
}
