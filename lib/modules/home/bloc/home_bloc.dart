import 'package:app/constants/route_paths/app_route_path.dart';
import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/day/day_bloc.dart';
import 'package:app/core/services/app_navigator_service.dart';
import 'package:app/core/services/date_service.dart';
import 'package:app/modules/home/bloc/home_actions.dart';
import 'package:app/modules/home/bloc/home_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeActions, HomeQuery> {
  final BookQuery bookQuery;
  final BookBloc bookBloc;
  final DayBloc dayBloc;
  final AppNavigatorService appNavigatorService;

  HomeBloc({
    required this.bookQuery,
    required this.bookBloc,
    required this.dayBloc,
    required this.appNavigatorService,
  }) : super(HomeQuery(bookQuery: bookQuery));

  @override
  Stream<HomeQuery> mapEventToState(HomeActions event) async* {
    if (event is HomeActionsUpdatePage) {
      _updateBookReadPage(event.bookId, event.newPage);
    } else if (event is HomeActionsNavigateToBookDetails) {
      _navigateToBookDetails(event.bookId);
    }
  }

  _updateBookReadPage(String bookId, int newPage) async {
    int bookReadPages = await bookQuery.selectReadPages(bookId).first;
    int bookPages = await bookQuery.selectPages(bookId).first;
    if (newPage >= bookPages) {
      bookBloc.updateBook(
        bookId: bookId,
        readPages: bookPages,
        status: BookStatus.end,
      );
      await dayBloc.addPages(
        dayId: DateService.getCurrentDate(),
        bookId: bookId,
        pagesToAdd: bookPages - bookReadPages,
      );
    } else {
      bookBloc.updateBook(bookId: bookId, readPages: newPage);
      if (newPage < bookReadPages) {
        await dayBloc.deletePages(
          bookId: bookId,
          pagesToDelete: bookReadPages - newPage,
        );
      } else {
        await dayBloc.addPages(
          dayId: DateService.getCurrentDate(),
          bookId: bookId,
          pagesToAdd: newPage - bookReadPages,
        );
      }
    }
  }

  _navigateToBookDetails(String bookId) {
    appNavigatorService.pushNamed(path: AppRoutePath.BOOK_DETAILS, arguments: {
      'bookId': bookId,
    });
  }
}
