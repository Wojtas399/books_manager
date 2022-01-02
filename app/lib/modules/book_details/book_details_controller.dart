import 'package:app/core/book/book_model.dart';
import 'package:app/modules/book_details/bloc/book_details_actions.dart';
import 'package:app/modules/book_details/bloc/book_details_bloc.dart';
import 'package:app/modules/book_details/bloc/book_details_query.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_model.dart';
import 'package:app/modules/book_details/elements/book_details_action_sheet.dart';
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
    required BookDetailsQuery query,
    required BookDetailsBloc bloc,
    required BookDetailsDialogs bookDetailsDialogs,
    required ImagePicker imagePicker,
  }) {
    _query = query;
    _bloc = bloc;
    _bookDetailsDialogs = bookDetailsDialogs;
    _imagePicker = imagePicker;
  }

  onClickFunctionalButton() {
    _query.status$.take(1).map(
      (bookStatus) {
        if (bookStatus == BookStatus.read) {
          _bloc.add(BookDetailsActionsPauseReading());
        } else {
          _bloc.add(BookDetailsActionsStartReading());
        }
      },
    ).listen((_) => _bookDetailsDialogs.showSuccessfullySavedInfo());
  }

  onClickEditButton() {
    _bookDetailsDialogs.askForEditOperation().whereType().switchMap((result) {
      switch (result) {
        case BookDetailsEditAction.editImage:
          return _changeImage();
        case BookDetailsEditAction.editDetails:
          return _changeDetails();
        default:
          return Stream.empty();
      }
    }).listen((_) {});
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

  Stream<void> _changeImage() {
    return _getImageFromGallery()
        .whereType<String>()
        .switchMap((String imgPath) => Rx.combineLatest2(
              Stream<String>.value(imgPath),
              _bookDetailsDialogs.askForNewImageConfirmation(imgPath),
              (String imgPath, bool? confirmation) {
                if (confirmation == true) {
                  _bloc.add(BookDetailsActionsUpdateImg(newImgPath: imgPath));
                  return true;
                }
                return false;
              },
            ))
        .where((imageChanged) => imageChanged == true)
        .map((_) => _bookDetailsDialogs.showSuccessfullySavedInfo());
  }

  Stream<void> _changeDetails() {
    return Rx.combineLatest2(
            _query.category$,
            _query.bookDetails$,
            (BookCategory category, BookDetailsModel bookDetails) =>
                BookDetailsEditModel(
                  title: bookDetails.title,
                  author: bookDetails.author,
                  category: category,
                  readPages: bookDetails.readPages,
                  pages: bookDetails.pages,
                ))
        .take(1)
        .switchMap((BookDetailsEditModel details) => Rx.combineLatest2(
                Stream<BookDetailsEditModel>.value(details),
                _bookDetailsDialogs.askForNewBookDetails(details), (
              BookDetailsEditModel details,
              BookDetailsEditedDataModel? newDetails,
            ) {
              if (newDetails != null) {
                return [newDetails, details];
              }
            }))
        .whereType<List>()
        .where((values) => values.length == 2)
        .switchMap((values) => _saveNewBookDetails(
              values[0] as BookDetailsEditedDataModel,
              values[1] as BookDetailsEditModel,
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

  Stream<void> _saveNewBookDetails(
    BookDetailsEditedDataModel? newBookDetails,
    BookDetailsEditModel bookDetails,
  ) {
    int? newReadPages = newBookDetails?.readPages;
    int? newPages = newBookDetails?.pages;
    bool isEndReading = false;
    return _isBookEnded(
      bookDetails.readPages,
      bookDetails.pages,
      newBookDetails?.readPages,
      newBookDetails?.pages,
    )
        .take(1)
        .switchMap((isEnded) {
          if (isEnded) {
            isEndReading = true;
            return _bookDetailsDialogs.askForEndReadingBookConfirmation();
          }
          return Stream<bool>.value(true);
        })
        .where((confirmation) => confirmation == true)
        .map((_) => _bloc.add(BookDetailsActionsUpdateBook(
              title: newBookDetails?.title,
              author: newBookDetails?.author,
              category: newBookDetails?.category,
              readPages: isEndReading
                  ? newPages != null
                      ? newPages
                      : bookDetails.pages
                  : newReadPages,
              pages: newPages,
              status: isEndReading ? BookStatus.end : null,
            )))
        .map((_) => _bookDetailsDialogs.showSuccessfullySavedInfo());
  }

  Stream<bool> _isBookEnded(
    int readPages,
    int pages,
    int? newReadPages,
    int? newPages,
  ) async* {
    if (newReadPages != null && newPages != null) {
      yield newReadPages >= newPages;
    } else if (newReadPages != null) {
      yield newReadPages >= pages;
    } else if (newPages != null) {
      yield readPages >= newPages;
    }
    yield false;
  }
}
