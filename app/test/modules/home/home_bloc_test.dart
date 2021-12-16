import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/day/day_bloc.dart';
import 'package:app/core/services/date_service.dart';
import 'package:app/modules/home/bloc/home_actions.dart';
import 'package:app/modules/home/bloc/home_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../global_mocks.dart';

void main() {
  BookQuery bookQuery = MockBookQuery();
  BookBloc bookBloc = MockBookBloc();
  DayBloc dayBloc = MockDayBloc();
  late HomeBloc bloc;

  setUp(() {
    bloc = HomeBloc(
      bookQuery: bookQuery,
      bookBloc: bookBloc,
      dayBloc: dayBloc,
    );
  });

  tearDown(() {
    reset(bookQuery);
    reset(bookBloc);
    reset(dayBloc);
  });

  group('update book read pages', () {
    setUp(() {
      when(() => bookQuery.selectReadPages('b1'))
          .thenAnswer((_) => Stream.value(50));
      when(() => bookQuery.selectPages('b1'))
          .thenAnswer((_) => Stream.value(200));
    });

    blocTest(
      'new page number higher than the last page number',
      build: () => bloc,
      act: (HomeBloc b) => b.add(HomeBlocUpdatePage(
        bookId: 'b1',
        newPage: 250,
      )),
      verify: (_) {
        verify(
          () => bookBloc.updateBook(
            bookId: 'b1',
            readPages: 200,
            status: BookStatus.end,
          ),
        ).called(1);
        verify(
          () => dayBloc.addPages(
            dayId: DateService.getCurrentDate(),
            bookId: 'b1',
            pagesToAdd: 150,
          ),
        ).called(1);
      },
    );

    blocTest(
      'new page number lower than current page number',
      build: () => bloc,
      act: (HomeBloc b) => b.add(HomeBlocUpdatePage(
        bookId: 'b1',
        newPage: 25,
      )),
      verify: (_) {
        verify(
          () => bookBloc.updateBook(
            bookId: 'b1',
            readPages: 25,
          ),
        ).called(1);
        verify(
          () => dayBloc.deletePages(
            bookId: 'b1',
            pagesToDelete: 25,
          ),
        ).called(1);
      },
    );

    blocTest(
      'new page number higher than current page number',
      build: () => bloc,
      act: (HomeBloc b) => b.add(HomeBlocUpdatePage(
        bookId: 'b1',
        newPage: 125,
      )),
      verify: (_) {
        verify(
          () => bookBloc.updateBook(
            bookId: 'b1',
            readPages: 125,
          ),
        ).called(1);
        verify(
          () => dayBloc.addPages(
            dayId: DateService.getCurrentDate(),
            bookId: 'b1',
            pagesToAdd: 75,
          ),
        ).called(1);
      },
    );
  });
}
