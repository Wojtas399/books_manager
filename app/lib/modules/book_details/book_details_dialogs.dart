import 'package:app/common/ui/action_sheet.dart';
import 'package:app/common/ui/dialogs.dart';
import 'package:app/common/ui/snack_bars.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_model.dart';
import 'package:app/modules/book_details/elements/book_details_action_sheet.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_dialog.dart';
import 'package:app/modules/book_details/elements/book_details_new_image_preview.dart';

class BookDetailsDialogs {
  Future<BookDetailsEditAction?> askForEditOperation() async {
    return await ActionSheet.showActionSheet(BookDetailsActionSheet());
  }

  Future<bool?> askForNewImageConfirmation(String imgPath) async {
    return await Dialogs.showCustomDialog(
      child: BookDetailsNewImagePreview(
        imgPath: imgPath,
      ),
    );
  }

  Future<BookDetailsEditedDataModel?> askForNewBookDetails(
    BookDetailsEditModel bookDetails,
  ) async {
    return await Dialogs.showCustomDialog(
      child: BookDetailsEditDialog(
        bookDetails: bookDetails,
      ),
    );
  }

  Future<bool?> askForEndReadingBookConfirmation() async {
    return await Dialogs.showConfirmationDialog(
      title: 'Ostrzeżenie!',
      message:
          'W zmienionych szczegółach książki liczba stron przeczytanych jest większa lub równa liczbie wszystkich stron z książki. Spowoduje to oznaczenie książki jako przeczytanej. Czy chcesz kontunować?',
    );
  }

  Future<bool?> askForDeleteBookConfirmation(String bookTitle) async {
    return await Dialogs.showConfirmationDialog(
      title: 'Usuwanie książki',
      message: 'Czy na pewno chcesz usunąć książkę "$bookTitle?"',
    );
  }

  showSuccessfullySavedInfo() async {
    await SnackBars.showSnackBar('Pomyślnie zapisano zmiany');
  }
}
