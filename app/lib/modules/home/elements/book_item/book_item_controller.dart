import 'package:app/constants/route_paths/app_route_path.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/app_navigator_service.dart';
import 'package:app/modules/home/elements/book_item/book_item_action_sheet.dart';
import 'package:rxdart/rxdart.dart';
import '../../home_screen_dialogs.dart';
import 'book_item_model.dart';

class BookItemController {
  late String _bookId;
  late BookQuery _bookQuery;
  late HomeScreenDialogs _homeScreenDialogs;
  late AppNavigatorService _navigatorService;
  late Function(String bookId, int newPages) _updateBook;

  BookItemController({
    required String bookId,
    required BookQuery bookQuery,
    required HomeScreenDialogs homeScreenDialogs,
    required AppNavigatorService navigatorService,
    required Function(String bookId, int newPages) updateBook,
  }) {
    _bookId = bookId;
    _bookQuery = bookQuery;
    _homeScreenDialogs = homeScreenDialogs;
    _navigatorService = navigatorService;
    _updateBook = updateBook;
  }

  Stream<BookItemModel> get bookItemData$ => Rx.combineLatest5(
        _bookQuery.selectTitle(_bookId),
        _bookQuery.selectAuthor(_bookId),
        _bookQuery.selectReadPages(_bookId),
        _bookQuery.selectPages(_bookId),
        _bookQuery.selectImgUrl(_bookId),
        (
          String title,
          String author,
          int readPages,
          int pages,
          String imgUrl,
        ) =>
            BookItemModel(
          title: title,
          author: author,
          readPages: readPages,
          pages: pages,
          imgUrl: imgUrl,
        ),
      );

  onClickBookItem(String bookTitle) async {
    BookItemActionSheetResult? result =
        await _homeScreenDialogs.askForBookItemOperation(bookTitle);
    if (result == BookItemActionSheetResult.updatePage) {
      int bookReadPages = await _bookQuery.selectReadPages(_bookId).first;
      int bookPages = await _bookQuery.selectPages(_bookId).first;
      int? newPage = await _homeScreenDialogs.askForNewPage(bookReadPages);
      if (newPage != null &&
          await _checkNewPage(newPage, bookReadPages, bookPages)) {
        _updateBook(_bookId, newPage);
        await _homeScreenDialogs.showSuccessfullyUpdatedInfo();
      }
    } else if (result == BookItemActionSheetResult.bookDetails) {
      _navigatorService.pushNamed(path: AppRoutePath.BOOK_DETAILS, arguments: {
        'bookId': _bookId,
      });
    }
  }

  Future<bool> _checkNewPage(
    int newPage,
    int currentPage,
    int allPages,
  ) async {
    if (newPage > currentPage && newPage < allPages) {
      return true;
    } else if (newPage < currentPage && newPage >= 0) {
      bool? confirmation =
          await _homeScreenDialogs.askForLowerPageConfirmation();
      return confirmation == true;
    } else if (newPage < 0) {
      await _homeScreenDialogs.showWrongPageInfo();
      return false;
    } else if (newPage >= allPages) {
      bool? confirmation = await _homeScreenDialogs.askForEndBookConfirmation();
      return confirmation == true;
    }
    return false;
  }
}
