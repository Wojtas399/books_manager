import 'package:app/common/ui/dialogs.dart';
import 'package:app/modules/library/filter_dialog/filter_dialog_controller.dart';

import 'filter_dialog/filter_dialog.dart';

class LibraryDialogs {
  Future<FilterOptions?> askForFilterOptions(
    FilterOptions filterOptions,
  ) async {
    return await Dialogs.showCustomDialog(
      child: FilterDialog(filterOptions: filterOptions),
    );
  }

  showWrongPagesInfo() async {
    await Dialogs.showInfoDialog(
      header: 'Nieprawidłowe strony',
      message:
          'Podano nieprawidłową minimalną lub maksymalną liczbę stron. Obie te wartości muszą być nieujemne oraz minimalna liczba stron musi być mniejsza od maksymalnej liczby stron',
    );
  }
}
