import 'package:app/modules/home/bloc/home_actions.dart';
import 'package:app/modules/home/bloc/home_bloc.dart';
import 'package:app/modules/home/bloc/home_query.dart';
import 'package:app/modules/home/elements/book_item/book_item_action_sheet.dart';
import '../../home_screen_dialogs.dart';

class BookItemController {
  late String _bookId;
  late HomeQuery _query;
  late HomeBloc _bloc;
  late HomeScreenDialogs _dialogs;

  BookItemController({
    required String bookId,
    required HomeQuery homeQuery,
    required HomeBloc homeBloc,
    required HomeScreenDialogs homeScreenDialogs,
  }) {
    _bookId = bookId;
    _query = homeQuery;
    _bloc = homeBloc;
    _dialogs = homeScreenDialogs;
  }

  Stream<BookItemDetails> get bookItemDetails$ =>
      _query.selectBookItemDetails(_bookId);

  onClickBookItem() async {
    BookItemDetails bookItemDetails = await bookItemDetails$.first;
    Stream<BookItemActions> selectedAction$ =
        _dialogs.askForBookItemAction(bookItemDetails.title);
    await for (BookItemActions actionValue in selectedAction$) {
      switch (actionValue) {
        case BookItemActions.updatePage:
          await _updatePage(bookItemDetails.readPages, bookItemDetails.pages);
          break;
        case BookItemActions.navigateToBookDetails:
          _bloc.add(HomeActionsNavigateToBookDetails(bookId: _bookId));
          break;
        default:
          break;
      }
    }
  }

  _updatePage(int readPages, int pages) async {
    Stream<int> newSelectedPage$ = _dialogs.askForNewPage(readPages);
    await for (int selectedPageValue in newSelectedPage$) {
      bool confirmation = await _newPageConfirmation(
        selectedPageValue,
        readPages,
        pages,
      ).first;
      if (confirmation) {
        _bloc.add(HomeActionsUpdatePage(
          bookId: _bookId,
          newPage: selectedPageValue,
        ));
        _dialogs.showSuccessfullyUpdatedInfo();
      }
    }
  }

  Stream<bool> _newPageConfirmation(
    int newPage,
    int currentPage,
    int allPages,
  ) {
    if (_isPageHigherThanCurrentPage(newPage, currentPage, allPages)) {
      return Stream.value(true);
    } else if (_isPageLowerThanCurrentPage(newPage, currentPage)) {
      return _dialogs.askForLowerPageConfirmation();
    } else if (_isWrongPageNumber(newPage)) {
      _dialogs.showWrongPageInfo();
      return Stream.value(false);
    } else if (_isPageHigherThanOrEqualTheLastPage(newPage, allPages)) {
      return _dialogs.askForEndBookConfirmation();
    }
    return Stream.value(false);
  }

  bool _isPageHigherThanCurrentPage(
    int newPage,
    int currentPage,
    int allPages,
  ) {
    return newPage > currentPage && newPage < allPages;
  }

  bool _isPageLowerThanCurrentPage(int newPage, int currentPage) {
    return newPage < currentPage && newPage > 0;
  }

  bool _isWrongPageNumber(int newPage) {
    return newPage < 0;
  }

  bool _isPageHigherThanOrEqualTheLastPage(int newPage, int allPages) {
    return newPage > allPages;
  }
}
