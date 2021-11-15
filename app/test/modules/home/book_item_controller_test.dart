import 'package:app/constants/route_paths/app_route_path.dart';
import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/day/day_bloc.dart';
import 'package:app/core/services/date_service.dart';
import 'package:app/core/services/app_navigator_service.dart';
import 'package:app/modules/home/elements/book_item/book_item_action_sheet.dart';
import 'package:app/modules/home/elements/book_item/book_item_controller.dart';
import 'package:app/modules/home/elements/book_item/book_item_model.dart';
import 'package:app/modules/home/home_screen_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import '../global_mocks.dart';

class MockHomeScreenDialogs extends Mock implements HomeScreenDialogs {}

void main() {
  BookQuery bookQuery = MockBookQuery();
  BookBloc bookBloc = MockBookBloc();
  DayBloc dayBloc = MockDayBloc();
  HomeScreenDialogs homeScreenDialogs = MockHomeScreenDialogs();
  AppNavigatorService navigatorService = MockAppNavigatorService();
  late BookItemController controller;

  setUp(() => controller = BookItemController(
        bookId: 'b1',
        bookQuery: bookQuery,
        bookBloc: bookBloc,
        dayBloc: dayBloc,
        homeScreenDialogs: homeScreenDialogs,
        navigatorService: navigatorService,
      ));

  tearDown(() {
    reset(bookQuery);
    reset(bookBloc);
    reset(dayBloc);
    reset(homeScreenDialogs);
    reset(navigatorService);
  });

  group('bookItemData', () {
    setUp(() {
      when(() => bookQuery.selectTitle('b1'))
          .thenAnswer((_) => new BehaviorSubject<String>.seeded('Book title'));
      when(() => bookQuery.selectAuthor('b1'))
          .thenAnswer((_) => new BehaviorSubject<String>.seeded('Author name'));
      when(() => bookQuery.selectReadPages('b1'))
          .thenAnswer((_) => new BehaviorSubject<int>.seeded(200));
      when(() => bookQuery.selectPages('b1'))
          .thenAnswer((_) => new BehaviorSubject<int>.seeded(400));
      when(() => bookQuery.selectImgUrl('b1'))
          .thenAnswer((_) => new BehaviorSubject<String>.seeded('img/url'));
    });

    test('Should be the book item data', () async {
      BookItemModel data = await controller.bookItemData$.first;
      expect(data, isA<BookItemModel>());
      expect(data.title, 'Book title');
      expect(data.author, 'Author name');
      expect(data.readPages, 200);
      expect(data.pages, 400);
      expect(data.imgUrl, 'img/url');
    });
  });

  group('openBookItemActionSheet', () {
    setUp(() {
      when(() => homeScreenDialogs.askForBookItemOperation('Book title'))
          .thenAnswer((_) async => BookItemActionSheetResult.updatePage);
      when(() => bookQuery.selectReadPages('b1'))
          .thenAnswer((_) => new BehaviorSubject<int>.seeded(200));
      when(() => bookQuery.selectPages('b1'))
          .thenAnswer((_) => new BehaviorSubject<int>.seeded(350));
    });

    group('updatePage', () {
      group('when new page is higher than current page', () {
        setUp(() async {
          when(() => homeScreenDialogs.askForNewPage(200))
              .thenAnswer((_) async => 250);
          await controller.onClickBookItem('Book title');
        });

        test('should call update method with new page', () {
          verify(() => bookBloc.updateBook(
                bookId: 'b1',
                readPages: 250,
              )).called(1);
        });

        test('should call add pages to day method with new read pages', () {
          verify(() => dayBloc.addPages(
                dayId: DateService.getCurrentDate(),
                bookId: 'b1',
                pagesToAdd: 50,
              )).called(1);
        });
      });

      group('when new page is lower than current page', () {
        setUp(() {
          when(() => homeScreenDialogs.askForNewPage(200))
              .thenAnswer((_) async => 150);
        });

        group('confirmed', () {
          setUp(() async {
            when(() => homeScreenDialogs.askForLowerPageConfirmation())
                .thenAnswer((_) async => true);
            await controller.onClickBookItem('Book title');
          });

          test('should call update method with new page', () {
            verify(() => bookBloc.updateBook(
                  bookId: 'b1',
                  readPages: 150,
                )).called(1);
          });

          test(
            'should call delete pages from days method with deleted pages',
            () {
              verify(() => dayBloc.deletePages(
                    bookId: 'b1',
                    pagesToDelete: 50,
                  )).called(1);
            },
          );
        });

        group('cancelled', () {
          setUp(() async {
            when(() => homeScreenDialogs.askForLowerPageConfirmation())
                .thenAnswer((_) async => false);
            await controller.onClickBookItem('Book title');
          });

          test('should not call update method', () {
            verifyNever(() => bookBloc.updateBook(
                  bookId: 'b1',
                  readPages: 150,
                ));
          });

          test('should not call delete pages from days method', () {
            verifyNever(() => dayBloc.deletePages(
                  bookId: 'b1',
                  pagesToDelete: 50,
                ));
          });
        });
      });

      group('when new page is lower than 0', () {
        setUp(() async {
          when(() => homeScreenDialogs.askForNewPage(200))
              .thenAnswer((_) async => -1);
          await controller.onClickBookItem('Book title');
        });

        test('should not call update method', () {
          verifyNever(() => bookBloc.updateBook(
                bookId: 'b1',
                readPages: -1,
              ));
        });

        test('should not call delete pages from days method', () {
          verifyNever(() => dayBloc.deletePages(
                bookId: 'b1',
                pagesToDelete: 201,
              ));
        });
      });

      group('when new page is higher than the last page number', () {
        setUp(() {
          when(() => homeScreenDialogs.askForNewPage(200))
              .thenAnswer((_) async => 401);
        });

        group('confirmed', () {
          setUp(() async {
            when(() => homeScreenDialogs.askForEndBookConfirmation())
                .thenAnswer((_) async => true);
            await controller.onClickBookItem('Book title');
          });

          test('should call update method with new page and end status', () {
            verify(() => bookBloc.updateBook(
                  bookId: 'b1',
                  readPages: 350,
                  status: BookStatus.end,
                )).called(1);
          });

          test(
            'should call add pages to day method with the rest of pages',
            () {
              verify(() => dayBloc.addPages(
                    dayId: DateService.getCurrentDate(),
                    bookId: 'b1',
                    pagesToAdd: 150,
                  )).called(1);
            },
          );
        });

        group('cancelled', () {
          setUp(() async {
            when(() => homeScreenDialogs.askForEndBookConfirmation())
                .thenAnswer((_) async => false);
            await controller.onClickBookItem('Book title');
          });

          test('should not call update method', () {
            verifyNever(
              () => bookBloc.updateBook(
                bookId: 'b1',
                readPages: 350,
                status: BookStatus.end,
              ),
            );
          });

          test('should not call add pages to day method', () {
            verifyNever(() => dayBloc.addPages(
                  dayId: DateService.getCurrentDate(),
                  bookId: 'b1',
                  pagesToAdd: 150,
                ));
          });
        });
      });
    });

    group('bookDetails', () {
      setUp(() async {
        when(() => homeScreenDialogs.askForBookItemOperation('Book title'))
            .thenAnswer((_) async => BookItemActionSheetResult.bookDetails);
        await controller.onClickBookItem('Book title');
      });

      test('should navigate to book details page', () {
        verify(() => navigatorService.pushNamed(
              path: AppRoutePath.BOOK_DETAILS,
              arguments: {'bookId': 'b1'},
            )).called(1);
      });
    });
  });
}
