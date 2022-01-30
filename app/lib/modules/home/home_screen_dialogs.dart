import 'package:app/common/ui/action_sheet.dart';
import 'package:app/common/ui/dialogs.dart';
import 'package:app/common/ui/snack_bars.dart';
import 'package:app/modules/home/elements/book_item/book_item_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenDialogs {
  Stream<BookItemActions> askForBookItemAction(
    String bookTitle,
  ) {
    return Rx.fromCallable(
      () => ActionSheet.showActionSheet(
        BookItemActionSheet(bookTitle: bookTitle),
      ),
    ).whereType<BookItemActions>();
  }

  Stream<int> askForNewPage(int currentPage) {
    return Rx.fromCallable(
      () => Dialogs.showSingleInputDialog(
        type: TextInputType.number,
        title: 'Zaktualizuj stronę',
        label: 'Obecna strona',
        controller: TextEditingController(text: currentPage.toString()),
      ),
    ).whereType<String>().map((newReadPages) => int.parse(newReadPages));
  }

  Stream<bool> askForLowerPageConfirmation() {
    return Rx.fromCallable(
      () => Dialogs.showConfirmationDialog(
        title: 'Aktualizacja strony',
        message:
            'Podano stronę wcześniejszą niż dotychczasowa. Spowoduje to utratę niektórych danych dotyczących czytanych stron. Czy chcesz kontynuować?',
      ),
    ).whereType<bool>();
  }

  Stream<bool> askForEndBookConfirmation() {
    return Rx.fromCallable(
      () => Dialogs.showConfirmationDialog(
        title: 'Aktualizacja strony',
        message:
            'Podana strona wybiega poza zakres wszystkich stron książki lub jest ostatnią stroną. Spowoduje to zakończenie czytania tejże książki. Czy chcesz kontynować?',
      ),
    ).whereType<bool>();
  }

  showWrongPageInfo() {
    Dialogs.showInfoDialog(
      header: 'Błąd...',
      message: 'Podano zły numer strony...',
    );
  }

  showSuccessfullyUpdatedInfo() {
    SnackBars.showSnackBar('Pomyślnie zapisano zmiany');
  }
}
