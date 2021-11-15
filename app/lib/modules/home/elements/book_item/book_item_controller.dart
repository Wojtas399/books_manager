import 'package:app/constants/route_paths/app_route_path.dart';
import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/day/day_bloc.dart';
import 'package:app/core/services/date_service.dart';
import 'package:app/core/services/app_navigator_service.dart';
import 'package:app/modules/home/elements/book_item/book_item_action_sheet.dart';
import 'package:rxdart/rxdart.dart';
import '../../home_screen_dialogs.dart';
import 'book_item_model.dart';

class BookItemController {
  late String _bookId;
  late BookQuery _bookQuery;
  late BookBloc _bookBloc;
  late DayBloc _dayBloc;
  late HomeScreenDialogs _homeScreenDialogs;
  late AppNavigatorService _navigatorService;

  BookItemController({
    required String bookId,
    required BookQuery bookQuery,
    required BookBloc bookBloc,
    required DayBloc dayBloc,
    required HomeScreenDialogs homeScreenDialogs,
    required AppNavigatorService navigatorService,
  }) {
    _bookId = bookId;
    _bookQuery = bookQuery;
    _bookBloc = bookBloc;
    _dayBloc = dayBloc;
    _homeScreenDialogs = homeScreenDialogs;
    _navigatorService = navigatorService;
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
        await _homeScreenDialogs.askForBookItemOperation(
      bookTitle,
    );
    if (result == BookItemActionSheetResult.updatePage) {
      int bookReadPages = await _bookQuery.selectReadPages(_bookId).first;
      int bookPages = await _bookQuery.selectPages(_bookId).first;
      int? newPage = await _homeScreenDialogs.askForNewPage(bookReadPages);
      if (newPage != null &&
          await _checkNewPage(newPage, bookReadPages, bookPages)) {
        if (newPage >= bookPages) {
          await _bookBloc.updateBook(
            bookId: _bookId,
            readPages: bookPages,
            status: BookStatus.end,
          );
          await _dayBloc.addPages(
            dayId: DateService.getCurrentDate(),
            bookId: _bookId,
            pagesToAdd: bookPages - bookReadPages,
          );
        } else {
          await _bookBloc.updateBook(
            bookId: _bookId,
            readPages: newPage,
          );
          if (newPage < bookReadPages) {
            await _dayBloc.deletePages(
              bookId: _bookId,
              pagesToDelete: bookReadPages - newPage,
            );
          } else {
            await _dayBloc.addPages(
              dayId: DateService.getCurrentDate(),
              bookId: _bookId,
              pagesToAdd: newPage - bookReadPages,
            );
          }
        }
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
