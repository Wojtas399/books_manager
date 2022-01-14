import 'package:app/common/ui/action_sheet.dart';
import 'package:app/common/ui/dialogs.dart';
import 'package:app/common/ui/snack_bars.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_model.dart';
import 'package:app/modules/book_details/elements/book_details_action_sheet.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_dialog.dart';
import 'package:app/modules/book_details/elements/book_details_new_image_preview.dart';
import 'package:rxdart/rxdart.dart';

class BookDetailsDialogs {
  Stream<BookDetailsEditAction?> askForEditOperation() {
    return Rx.fromCallable(
      () => ActionSheet.showActionSheet(BookDetailsActionSheet()),
    ).map((action) => action);
  }

  Stream<bool?> askForNewImageConfirmation(String imgPath) {
    return Rx.fromCallable(
      () => Dialogs.showCustomDialog(
        child: BookDetailsNewImagePreview(imgPath: imgPath),
      ),
    ).map((confirmation) => confirmation);
  }

  Stream<BookDetailsEditedDataModel?> askForNewBookDetails(
    BookDetailsEditModel bookDetails,
  ) {
    return Rx.fromCallable(
      () => Dialogs.showCustomDialog(
        child: BookDetailsEditDialog(bookDetails: bookDetails),
      ),
    ).map((newDetails) => newDetails);
  }

  Stream<bool?> askForEndReadingBookConfirmation() {
    return Rx.fromCallable(
      () => Dialogs.showConfirmationDialog(
        title: 'Ostrzeżenie!',
        message:
            'W zmienionych szczegółach książki liczba stron przeczytanych jest większa lub równa liczbie wszystkich stron z książki. Spowoduje to oznaczenie książki jako przeczytanej. Czy chcesz kontunować?',
      ),
    ).map((confirmation) => confirmation);
  }

  Stream<bool?> askForDeleteBookConfirmation(String bookTitle) {
    return Rx.fromCallable(
      () => Dialogs.showConfirmationDialog(
        title: 'Usuwanie książki',
        message: 'Czy na pewno chcesz usunąć książkę "$bookTitle?"',
      ),
    ).map((confirmation) => confirmation);
  }

  showSuccessfullySavedInfo(String text) {
    SnackBars.showSnackBar(text);
  }
}
