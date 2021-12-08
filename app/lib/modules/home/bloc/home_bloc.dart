import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/day/day_bloc.dart';
import 'package:app/core/services/date_service.dart';
import 'package:app/modules/home/bloc/home_actions.dart';
import 'package:app/modules/home/bloc/home_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeActions, HomeQuery> {
  final BookQuery bookQuery;
  final BookBloc bookBloc;
  final DayBloc dayBloc;

  HomeBloc({
    required this.bookQuery,
    required this.bookBloc,
    required this.dayBloc,
  }) : super(HomeQuery(bookQuery: bookQuery));

  @override
  Stream<HomeQuery> mapEventToState(HomeActions event) async* {
    if (event is UpdatePages) {
      _updateBook(event.bookId, event.newPage);
    }
  }

  _updateBook(String bookId, int newPage) async {
    int bookReadPages = await bookQuery.selectReadPages(bookId).first;
    int bookPages = await bookQuery.selectPages(bookId).first;
    if (newPage >= bookPages) {
      await bookBloc.updateBook(
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
      await bookBloc.updateBook(
        bookId: bookId,
        readPages: newPage,
      );
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
}
