import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_model.dart';
import 'package:app/modules/book_details/elements/book_details_action_sheet.dart';
import 'package:app/modules/book_details/book_details_model.dart';
import 'package:app/modules/book_details/book_details_dialogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class BookDetailsController {
  late final String _bookId;
  late BookQuery _bookQuery;
  late BookCategoryService _bookCategoryService;
  late BookDetailsDialogs _bookDetailsDialogs;
  late BookBloc _bookBloc;
  late ImagePicker _imagePicker;

  BookDetailsController({
    required String bookId,
    required BookQuery bookQuery,
    required BookCategoryService bookCategoryService,
    required BookDetailsDialogs bookDetailsDialogs,
    required BookBloc bookBloc,
    required ImagePicker imagePicker,
  }) {
    _bookId = bookId;
    _bookQuery = bookQuery;
    _bookCategoryService = bookCategoryService;
    _bookDetailsDialogs = bookDetailsDialogs;
    _bookBloc = bookBloc;
    _imagePicker = imagePicker;
  }

  Stream<BookCategory> get _bookCategory$ => _bookQuery.selectCategory(_bookId);

  Stream<BookStatus> get bookStatus$ => _bookQuery.selectStatus(_bookId);

  Stream<BookDetailsModel> get bookDetails$ => Rx.combineLatest9(
        _bookQuery.selectTitle(_bookId),
        _bookQuery.selectAuthor(_bookId),
        _bookCategory$,
        _bookQuery.selectImgUrl(_bookId),
        _bookQuery.selectReadPages(_bookId),
        _bookQuery.selectPages(_bookId),
        bookStatus$,
        _bookQuery.selectLastActualisationDate(_bookId),
        _bookQuery.selectAddDate(_bookId),
        (
          String title,
          String author,
          BookCategory category,
          String imgUrl,
          int readPages,
          int pages,
          BookStatus status,
          String lastActualisationDate,
          String addDate,
        ) =>
            BookDetailsModel(
          title: title,
          author: author,
          category: _bookCategoryService.convertCategoryToText(category),
          imgUrl: imgUrl,
          readPages: readPages,
          pages: pages,
          status: _convertStatusFromEnumToString(status),
          lastActualisation: lastActualisationDate,
          addDate: addDate,
        ),
      );

  onClickFunctionalButton() async {
    BookStatus bookStatus = await bookStatus$.first;
    if (bookStatus == BookStatus.read) {
      await _bookBloc.updateBook(
        bookId: _bookId,
        status: BookStatus.paused,
      );
    } else {
      await _bookBloc.updateBook(
        bookId: _bookId,
        status: BookStatus.read,
      );
    }
  }

  onClickEditButton() async {
    BookDetailsEditAction? result =
        await _bookDetailsDialogs.askForEditOperation();
    if (result != null) {
      switch (result) {
        case BookDetailsEditAction.editImage:
          await _changeImage();
          break;
        case BookDetailsEditAction.editDetails:
          await _changeDetails();
          break;
      }
    }
  }

  Future<bool> onClickDeleteButton() async {
    BookDetailsModel bookDetails = await bookDetails$.first;
    bool? confirmation = await _bookDetailsDialogs
        .askForDeleteBookConfirmation(bookDetails.title);
    if (confirmation == true) {
      await _bookBloc.deleteBook(bookId: _bookId);
      return true;
    }
    return false;
  }

  String _convertStatusFromEnumToString(BookStatus status) {
    switch (status) {
      case BookStatus.pending:
        return 'Oczekująca';
      case BookStatus.read:
        return 'W trakcie czytania';
      case BookStatus.end:
        return 'Przeczytana';
      case BookStatus.paused:
        return 'Wstrzymana';
    }
  }

  _changeImage() async {
    String? imgPath = await _getImageFromGallery();
    if (imgPath != null) {
      bool? confirmation =
          await _bookDetailsDialogs.askForNewImageConfirmation(imgPath);
      if (confirmation == true) {
        await _bookBloc.updateBookImg(
          bookId: _bookId,
          newImgPath: imgPath,
        );
        await _bookDetailsDialogs.showSuccessfullySavedInfo();
      }
    }
  }

  _changeDetails() async {
    BookCategory category = await _bookCategory$.first;
    BookDetailsModel bookDetails = await bookDetails$.first;
    BookDetailsEditModel details = BookDetailsEditModel(
      title: bookDetails.title,
      author: bookDetails.author,
      category: category,
      readPages: bookDetails.readPages,
      pages: bookDetails.pages,
    );
    BookDetailsEditedDataModel? newDetails =
        await _bookDetailsDialogs.askForNewBookDetails(details);
    await _saveNewBookDetails(newDetails, details);
  }

  Future<String?> _getImageFromGallery() async {
    try {
      final XFile? pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return pickedFile.path;
      }
      return null;
    } catch (error) {
      throw Exception(error);
    }
  }

  _saveNewBookDetails(
    BookDetailsEditedDataModel? newBookDetails,
    BookDetailsEditModel bookDetails,
  ) async {
    int? newReadPages = newBookDetails?.readPages;
    int? newPages = newBookDetails?.pages;
    bool endBook = false;
    if (_isBookEnded(
      bookDetails.readPages,
      bookDetails.pages,
      newReadPages,
      newPages,
    )) {
      bool? confirmation =
          await _bookDetailsDialogs.askForEndReadingBookConfirmation();
      if (confirmation == true) {
        endBook = true;
      }
    }
    await _bookBloc.updateBook(
      bookId: _bookId,
      title: newBookDetails?.title,
      author: newBookDetails?.author,
      category: newBookDetails?.category,
      readPages: endBook
          ? newPages != null
              ? newPages
              : bookDetails.pages
          : newReadPages,
      pages: newPages,
      status: endBook ? BookStatus.end : null,
    );
  }

  bool _isBookEnded(
    int readPages,
    int pages,
    int? newReadPages,
    int? newPages,
  ) {
    if (newReadPages != null && newPages != null) {
      return newReadPages >= newPages;
    } else if (newReadPages != null) {
      return newReadPages >= pages;
    } else if (newPages != null) {
      return readPages >= newPages;
    }
    return false;
  }
}
