import 'package:app/constants/route_paths/app_route_path.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/app_navigator_service.dart';
import 'package:app/modules/home/bloc/home_actions.dart';
import 'package:app/modules/home/bloc/home_bloc.dart';
import 'package:app/modules/home/elements/book_item/book_item_action_sheet.dart';
import 'package:app/modules/home/elements/book_item/book_item_controller.dart';
import 'package:app/modules/home/elements/book_item/book_item_model.dart';
import 'package:app/modules/home/home_screen_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import '../global_mocks.dart';

class MockHomeBloc extends Mock implements HomeBloc {}

class MockHomeScreenDialogs extends Mock implements HomeScreenDialogs {}

void main() {
  BookQuery bookQuery = MockBookQuery();
  HomeScreenDialogs dialogs = MockHomeScreenDialogs();
  AppNavigatorService navigatorService = MockAppNavigatorService();
  HomeBloc homeBloc = MockHomeBloc();
  late BookItemController controller;

  setUp(() {
    controller = BookItemController(
      bookId: 'b1',
      bookQuery: bookQuery,
      homeScreenDialogs: dialogs,
      navigatorService: navigatorService,
      homeBloc: homeBloc,
    );
  });

  tearDown(() {
    reset(bookQuery);
    reset(dialogs);
    reset(navigatorService);
  });

  test('book item data', () async {
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

    BookItemModel data = await controller.bookItemData$.first;
    expect(data, isA<BookItemModel>());
    expect(data.title, 'Book title');
    expect(data.author, 'Author name');
    expect(data.readPages, 200);
    expect(data.pages, 400);
    expect(data.imgUrl, 'img/url');
  });

  group('update page', () {
    setUp(() {
      when(() => dialogs.askForBookItemOperation('title'))
          .thenAnswer((_) async => BookItemActionSheetResult.updatePage);
      when(() => bookQuery.selectReadPages('b1'))
          .thenAnswer((_) => Stream.value(50));
      when(() => bookQuery.selectPages('b1'))
          .thenAnswer((_) => Stream.value(200));
    });

    test(
      'null',
      () async {
        when(() => dialogs.askForNewPage(50)).thenAnswer((_) async => null);

        await controller.onClickBookItem('title');

        verifyNever(
          () => homeBloc.add(HomeBlocUpdatePage(bookId: 'b1', newPage: 50)),
        );
      },
    );

    test(
      'new page higher than current page',
      () async {
        when(() => dialogs.askForNewPage(50)).thenAnswer((_) async => 100);

        await controller.onClickBookItem('title');

        verify(
          () => homeBloc.add(HomeBlocUpdatePage(bookId: 'b1', newPage: 100)),
        ).called(1);
      },
    );

    test(
      'new page lower than current page, confirmation confirmed',
      () async {
        when(() => dialogs.askForNewPage(50)).thenAnswer((_) async => 25);
        when(() => dialogs.askForLowerPageConfirmation())
            .thenAnswer((_) async => true);

        await controller.onClickBookItem('title');

        verify(
          () => homeBloc.add(HomeBlocUpdatePage(bookId: 'b1', newPage: 25)),
        ).called(1);
      },
    );

    test(
      'new page lower than current page, confirmation canceled',
      () async {
        when(() => dialogs.askForNewPage(50)).thenAnswer((_) async => 25);
        when(() => dialogs.askForLowerPageConfirmation())
            .thenAnswer((_) async => false);

        await controller.onClickBookItem('title');

        verifyNever(
          () => homeBloc.add(HomeBlocUpdatePage(bookId: 'b1', newPage: 25)),
        );
      },
    );

    test(
      'new page lower than 0',
      () async {
        when(() => dialogs.askForNewPage(50)).thenAnswer((_) async => -1);

        await controller.onClickBookItem('title');

        verifyNever(
          () => homeBloc.add(HomeBlocUpdatePage(bookId: 'b1', newPage: -1)),
        );
      },
    );

    test(
      'new page higher than the last page, confirmation confirmed',
      () async {
        when(() => dialogs.askForNewPage(50)).thenAnswer((_) async => 201);
        when(() => dialogs.askForEndBookConfirmation())
            .thenAnswer((_) async => true);

        await controller.onClickBookItem('title');

        verify(
          () => homeBloc.add(HomeBlocUpdatePage(bookId: 'b1', newPage: 201)),
        ).called(1);
      },
    );

    test(
      'new page higher than the last page, confirmation canceled',
      () async {
        when(() => dialogs.askForNewPage(50)).thenAnswer((_) async => 201);
        when(() => dialogs.askForEndBookConfirmation())
            .thenAnswer((_) async => false);

        await controller.onClickBookItem('title');

        verifyNever(
          () => homeBloc.add(HomeBlocUpdatePage(bookId: 'b1', newPage: 201)),
        );
      },
    );
  });

  test('navigate to book details', () async {
    when(() => dialogs.askForBookItemOperation('title'))
        .thenAnswer((_) async => BookItemActionSheetResult.bookDetails);

    await controller.onClickBookItem('title');

    verify(
      () => navigatorService.pushNamed(
        path: AppRoutePath.BOOK_DETAILS,
        arguments: {'bookId': 'b1'},
      ),
    ).called(1);
  });
}
