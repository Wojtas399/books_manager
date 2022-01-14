import 'package:app/core/book/book_model.dart';
import 'package:app/modules/book_details/bloc/book_details_actions.dart';
import 'package:app/modules/book_details/bloc/book_details_bloc.dart';
import 'package:app/modules/book_details/bloc/book_details_query.dart';
import 'package:app/modules/book_details/book_details_controller.dart';
import 'package:app/modules/book_details/book_details_dialogs.dart';
import 'package:app/modules/book_details/book_details_model.dart';
import 'package:app/modules/book_details/elements/book_details_action_sheet.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockBookDetailsQuery extends Mock implements BookDetailsQuery {}

class MockBookDetailsBloc extends Mock implements BookDetailsBloc {}

class MockBookDetailsDialogs extends Mock implements BookDetailsDialogs {}

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  BookDetailsQuery query = MockBookDetailsQuery();
  BookDetailsBloc bloc = MockBookDetailsBloc();
  BookDetailsDialogs bookDetailsDialogs = MockBookDetailsDialogs();
  ImagePicker imagePicker = MockImagePicker();
  late BookDetailsController controller;

  setUp(() {
    controller = BookDetailsController(
      bookDetailsQuery: query,
      bookDetailsBloc: bloc,
      bookDetailsDialogs: bookDetailsDialogs,
      imagePicker: imagePicker,
    );
  });

  tearDown(() {
    reset(query);
    reset(bloc);
    reset(bookDetailsDialogs);
    reset(imagePicker);
  });

  test('on click functional button, read status', () async {
    when(() => query.status$).thenAnswer((_) => Stream.value(BookStatus.read));

    await controller.onClickFunctionalButton();

    verify(() => bloc.add(BookDetailsActionsPauseReading())).called(1);
  });

  test('on click functional button, no read status', () async {
    when(() => query.status$).thenAnswer((_) => Stream.value(BookStatus.end));

    await controller.onClickFunctionalButton();

    verify(() => bloc.add(BookDetailsActionsStartReading())).called(1);
  });

  group('on click edit button, edit image', () {
    const imgPath = 'img/path';
    setUp(() {
      when(() => bookDetailsDialogs.askForEditOperation())
          .thenAnswer((_) => Stream.value(BookDetailsEditAction.editImage));
      when(() => imagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) => Future.value(XFile(imgPath)));
    });

    test('image selected, confirmed', () async {
      when(() => bookDetailsDialogs.askForNewImageConfirmation(imgPath))
          .thenAnswer((_) => Stream.value(true));

      await controller.onClickEditButton();

      verify(
        () => bloc.add(BookDetailsActionsUpdateImg(newImgPath: imgPath)),
      ).called(1);
    });

    test('image selected, canceled', () async {
      when(() => bookDetailsDialogs.askForNewImageConfirmation(imgPath))
          .thenAnswer((_) => Stream.value(false));

      await controller.onClickEditButton();

      verifyNever(
        () => bloc.add(BookDetailsActionsUpdateImg(newImgPath: imgPath)),
      );
    });
  });

  group('on click edit button, edit details', () {
    setUp(() {
      when(() => bookDetailsDialogs.askForEditOperation())
          .thenAnswer((_) => Stream.value(BookDetailsEditAction.editDetails));
    });

    group('end book reading', () {
      setUp(() {
        when(() => query.category$).thenAnswer(
          (_) => Stream.value(BookCategory.biography_autobiography),
        );
        when(() => query.bookDetails$).thenAnswer(
          (_) => Stream.value(
            createBookDetails(readPages: 100, pages: 500, status: 'czytane'),
          ),
        );
        when(
          () => bookDetailsDialogs.askForNewBookDetails(
            createBookDetailsEdit(readPages: 100, pages: 500),
          ),
        ).thenAnswer(
          (_) => Stream.value(createBookDetailsEditedData(readPages: 600)),
        );
      });

      test('confirmed', () async {
        when(() => bookDetailsDialogs.askForEndReadingBookConfirmation())
            .thenAnswer((_) => Stream.value(true));

        await controller.onClickEditButton();

        verify(
          () => bloc.add(BookDetailsActionsUpdateBook(
            readPages: 500,
            status: BookStatus.end,
          )),
        ).called(1);
      });

      test('canceled', () async {
        when(() => bookDetailsDialogs.askForEndReadingBookConfirmation())
            .thenAnswer((_) => Stream.value(false));

        await controller.onClickEditButton();

        verifyNever(
          () => bloc.add(BookDetailsActionsUpdateBook(
            readPages: 500,
            status: BookStatus.end,
          )),
        );
      });
    });

    test('normal changes', () async {
      final details = createBookDetails(
        title: 'Title',
        author: 'Author',
        category: 'Biografie i autobiografie',
        readPages: 100,
        pages: 500,
        status: 'czytane',
      );
      final editedDetails = createBookDetailsEditedData(
        title: 'New title',
        author: 'New author',
        category: BookCategory.academic_books,
        readPages: 200,
        pages: 700,
      );
      when(() => query.category$).thenAnswer(
        (_) => Stream.value(BookCategory.biography_autobiography),
      );
      when(() => query.bookDetails$).thenAnswer((_) => Stream.value(details));
      when(
        () => bookDetailsDialogs.askForNewBookDetails(
          createBookDetailsEdit(
            title: details.title,
            author: details.author,
            category: BookCategory.biography_autobiography,
            readPages: details.readPages,
            pages: details.pages,
          ),
        ),
      ).thenAnswer((_) => Stream.value(editedDetails));

      await controller.onClickEditButton();

      verify(
        () => bloc.add(BookDetailsActionsUpdateBook(
          title: editedDetails.title,
          author: editedDetails.author,
          category: editedDetails.category,
          readPages: editedDetails.readPages,
          pages: editedDetails.pages,
        )),
      ).called(1);
    });
  });

  test('on click delete button, accepted', () {
    when(() => query.title$).thenAnswer((_) => Stream.value('title'));
    when(
      () => bookDetailsDialogs.askForDeleteBookConfirmation('title'),
    ).thenAnswer((_) => Stream.value(true));

    controller.onClickDeleteButton().listen((_) {
      verify(() => bloc.add(BookDetailsActionsDeletedBook())).called(1);
    });
  });

  test('on click delete button, cancelled', () {
    when(() => query.title$).thenAnswer((_) => Stream.value('title'));
    when(
      () => bookDetailsDialogs.askForDeleteBookConfirmation('title'),
    ).thenAnswer((_) => Stream.value(false));

    controller.onClickDeleteButton().listen((_) {
      verifyNever(() => bloc.add(BookDetailsActionsDeletedBook()));
    });
  });
}
