import 'package:app/core/book/book_model.dart';
import 'package:app/modules/book_details/bloc/book_details_actions.dart';
import 'package:app/modules/book_details/bloc/book_details_bloc.dart';
import 'package:app/modules/book_details/bloc/book_details_query.dart';
import 'package:app/modules/book_details/elements/book_details_action_sheet.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_model.dart';
import 'package:app/modules/book_details/book_details_model.dart';
import 'package:app/modules/book_details/book_details_dialogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class BookDetailsController {
  late BookDetailsQuery _query;
  late BookDetailsBloc _bloc;
  late BookDetailsDialogs _bookDetailsDialogs;
  late ImagePicker _imagePicker;

  BookDetailsController({
    required BookDetailsQuery bookDetailsQuery,
    required BookDetailsBloc bookDetailsBloc,
    required BookDetailsDialogs bookDetailsDialogs,
    required ImagePicker imagePicker,
  }) {
    _query = bookDetailsQuery;
    _bloc = bookDetailsBloc;
    _bookDetailsDialogs = bookDetailsDialogs;
    _imagePicker = imagePicker;
  }

  Future<void> onClickFunctionalButton() async {
    BookStatus bookStatus = await _query.status$.first;
    if (bookStatus == BookStatus.read) {
      _bloc.add(BookDetailsActionsPauseReading());
    } else {
      _bloc.add(BookDetailsActionsStartReading());
    }
  }

  Future<void> onClickEditButton() async {
    Stream<BookDetailsEditAction> action$ = _bookDetailsDialogs
        .askForEditOperation()
        .whereType<BookDetailsEditAction>();
    await for (final val in action$) {
      switch (val) {
        case BookDetailsEditAction.editImage:
          await _changeImage();
          break;
        case BookDetailsEditAction.editDetails:
          await _changeDetails();
          break;
      }
    }
  }

  Stream<void> onClickDeleteButton() {
    return _query.title$
        .take(1)
        .switchMap(
          (title) => _bookDetailsDialogs.askForDeleteBookConfirmation(title),
        )
        .where((confirmation) => confirmation == true)
        .map((_) => _bloc.add(BookDetailsActionsDeletedBook()));
  }

  Future<void> _changeImage() async {
    Stream<String> imgPath$ = _getImageFromGallery().whereType<String>();
    await for (final imgPath in imgPath$) {
      _confirmImage(imgPath);
    }
  }

  Future<void> _changeDetails() async {
    BookDetailsEditModel details = await Rx.combineLatest2(
        _query.category$,
        _query.bookDetails$,
        (BookCategory category, BookDetailsModel bookDetails) =>
            BookDetailsEditModel(
              title: bookDetails.title,
              author: bookDetails.author,
              category: category,
              readPages: bookDetails.readPages,
              pages: bookDetails.pages,
            )).first;
    Stream<BookDetailsEditedDataModel> newDetails$ = _bookDetailsDialogs
        .askForNewBookDetails(details)
        .whereType<BookDetailsEditedDataModel>();
    await for (final newDetails in newDetails$) {
      _saveNewBookDetails(newDetails, details);
    }
  }

  void _confirmImage(String imgPath) {
    _bookDetailsDialogs
        .askForNewImageConfirmation(imgPath)
        .whereType<bool>()
        .where((confirmation) => confirmation == true)
        .map((_) => _bloc.add(
              BookDetailsActionsUpdateImg(newImgPath: imgPath),
            ))
        .listen((_) => _bookDetailsDialogs.showSuccessfullySavedInfo(
              'Pomyślnie zmieniono zdjęcie',
            ));
  }

  void _saveNewBookDetails(
    BookDetailsEditedDataModel? newBookDetails,
    BookDetailsEditModel bookDetails,
  ) {
    int? newReadPages = newBookDetails?.readPages;
    int? newPages = newBookDetails?.pages;
    bool isBookEnded = _isBookEnded(
      bookDetails.readPages,
      bookDetails.pages,
      newBookDetails?.readPages,
      newBookDetails?.pages,
    );
    Stream<bool> confirmation$ = isBookEnded
        ? _bookDetailsDialogs
            .askForEndReadingBookConfirmation()
            .whereType<bool>()
        : Stream<bool>.value(true);
    confirmation$
        .where((confirmation) => confirmation)
        .map((_) => _bloc.add(BookDetailsActionsUpdateBook(
              title: newBookDetails?.title,
              author: newBookDetails?.author,
              category: newBookDetails?.category,
              readPages: isBookEnded
                  ? newPages != null
                      ? newPages
                      : bookDetails.pages
                  : newReadPages,
              pages: newPages,
              status: isBookEnded ? BookStatus.end : null,
            )))
        .listen((_) => _bookDetailsDialogs.showSuccessfullySavedInfo(
              'Pomyślnie zmieniono dane',
            ));
  }

  Stream<String?> _getImageFromGallery() async* {
    try {
      final XFile? pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        yield pickedFile.path;
      }
      yield null;
    } catch (error) {
      throw Exception(error);
    }
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
