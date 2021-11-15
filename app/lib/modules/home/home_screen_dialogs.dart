import 'package:app/common/ui/action_sheet.dart';
import 'package:app/common/ui/dialogs.dart';
import 'package:app/common/ui/snack_bars.dart';
import 'package:app/modules/home/elements/book_item/book_item_action_sheet.dart';
import 'package:flutter/material.dart';

class HomeScreenDialogs {
  Future<BookItemActionSheetResult?> askForBookItemOperation(
    String bookTitle,
  ) async {
    return await ActionSheet.showActionSheet(
      BookItemActionSheet(bookTitle: bookTitle),
    );
  }

  Future<int?> askForNewPage(int currentPage) async {
    String? newVal = await Dialogs.showSingleInputDialog(
      type: TextInputType.number,
      title: 'Zaktualizuj stronę',
      label: 'Obecna strona',
      controller: TextEditingController(text: currentPage.toString()),
    );
    if (newVal != null) {
      int newReadPages = int.parse(newVal);
      return newReadPages;
    }
    return null;
  }

  Future<bool?> askForLowerPageConfirmation() async {
    return await Dialogs.showConfirmationDialog(
      title: 'Aktualizacja strony',
      message:
          'Podano stronę wcześniejszą niż dotychczasowa. Spowoduje to utratę niektórych danych dotyczących czytanych stron. Czy chcesz kontynuować?',
    );
  }

  showWrongPageInfo() async {
    await Dialogs.showInfoDialog(
      header: 'Błąd...',
      message: 'Podano zły numer strony...',
    );
  }

  Future<bool?> askForEndBookConfirmation() async {
    return await Dialogs.showConfirmationDialog(
      title: 'Aktualizacja strony',
      message:
          'Podana strona wybiega poza zakres wszystkich stron książki lub jest ostatnią stroną. Spowoduje to zakończenie czytania tejże książki. Czy chcesz kontynować?',
    );
  }

  Future<bool?> askForDeleteBookPagesConfirmation(
    String bookTitle,
    bool returnBook,
  ) async {
    String message = 'Ta operacja jest nieodwracalna i spowoduje usunięcie przeczytanych stron z dzisiejszego dnia';
    if (returnBook) {
      message += ', zmniejszenie liczby przeczytanych strony z książki "$bookTitle" oraz przywrócenie jej statusu "w trakcie czytania".';
    } else {
      message += ' oraz zmniejszenie liczby przeczytancyh stron z książki "$bookTitle".';
    }
    message += 'Czy chcesz kontynować?';
    return await Dialogs.showConfirmationDialog(
      title: 'Usuwanie przeczytanych stron',
      message: message,
    );
  }

  showSuccessfullyUpdatedInfo() async {
    await SnackBars.showSnackBar('Pomyślnie zapisano zmiany');
  }
}
