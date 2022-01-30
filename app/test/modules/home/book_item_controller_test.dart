import 'package:app/modules/home/bloc/home_actions.dart';
import 'package:app/modules/home/bloc/home_bloc.dart';
import 'package:app/modules/home/bloc/home_query.dart';
import 'package:app/modules/home/elements/book_item/book_item_action_sheet.dart';
import 'package:app/modules/home/elements/book_item/book_item_controller.dart';
import 'package:app/modules/home/home_screen_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeQuery extends Mock implements HomeQuery {}

class MockHomeBloc extends Mock implements HomeBloc {}

class MockHomeScreenDialogs extends Mock implements HomeScreenDialogs {}

void main() {
  HomeQuery homeQuery = MockHomeQuery();
  HomeBloc homeBloc = MockHomeBloc();
  HomeScreenDialogs dialogs = MockHomeScreenDialogs();
  late BookItemController controller;

  BookItemDetails bookItemDetails = BookItemDetails(
    title: 'title',
    author: 'author',
    readPages: 50,
    pages: 200,
    imgUrl: 'img/url',
  );

  setUp(() {
    controller = BookItemController(
      bookId: 'b1',
      homeQuery: homeQuery,
      homeBloc: homeBloc,
      homeScreenDialogs: dialogs,
    );
    when(() => homeQuery.selectBookItemDetails('b1')).thenAnswer(
      (_) => Stream.value(bookItemDetails),
    );
  });

  tearDown(() {
    reset(homeQuery);
    reset(homeBloc);
    reset(dialogs);
  });

  test('book item details', () async {
    BookItemDetails details = await controller.bookItemDetails$.first;

    expect(details, bookItemDetails);
  });

  group('on click book item, update page', () {
    setUp(() {
      when(() => dialogs.askForBookItemAction('title')).thenAnswer(
        (_) => Stream.value(BookItemActions.updatePage),
      );
    });

    test('page is higher than current page', () async {
      when(() => dialogs.askForNewPage(50)).thenAnswer(
        (_) => Stream.value(100),
      );

      await controller.onClickBookItem();

      verify(
        () => homeBloc.add(HomeActionsUpdatePage(bookId: 'b1', newPage: 100)),
      ).called(1);
    });

    test('page is lower than current page, confirmation accepted', () async {
      when(() => dialogs.askForNewPage(50)).thenAnswer(
        (_) => Stream.value(25),
      );
      when(() => dialogs.askForLowerPageConfirmation()).thenAnswer(
        (_) => Stream.value(true),
      );

      await controller.onClickBookItem();

      verify(
        () => homeBloc.add(HomeActionsUpdatePage(bookId: 'b1', newPage: 25)),
      ).called(1);
    });

    test('page is lower than current page, confirmation canceled', () async {
      when(() => dialogs.askForNewPage(50)).thenAnswer(
        (_) => Stream.value(25),
      );
      when(() => dialogs.askForLowerPageConfirmation()).thenAnswer(
        (_) => Stream.value(false),
      );

      await controller.onClickBookItem();

      verifyNever(
        () => homeBloc.add(HomeActionsUpdatePage(bookId: 'b1', newPage: 25)),
      );
    });

    test('wrong page number', () async {
      when(() => dialogs.askForNewPage(50)).thenAnswer(
        (_) => Stream.value(-20),
      );

      await controller.onClickBookItem();

      verifyNever(
        () => homeBloc.add(HomeActionsUpdatePage(bookId: 'b1', newPage: -20)),
      );
    });

    test('page is higher than the last page, confirmation accepted', () async {
      when(() => dialogs.askForNewPage(50)).thenAnswer(
        (_) => Stream.value(250),
      );
      when(() => dialogs.askForEndBookConfirmation()).thenAnswer(
        (_) => Stream.value(true),
      );

      await controller.onClickBookItem();

      verify(
        () => homeBloc.add(HomeActionsUpdatePage(bookId: 'b1', newPage: 250)),
      ).called(1);
    });

    test('page is higher than the last page, confirmation canceled', () async {
      when(() => dialogs.askForNewPage(50)).thenAnswer(
        (_) => Stream.value(250),
      );
      when(() => dialogs.askForEndBookConfirmation()).thenAnswer(
        (_) => Stream.value(false),
      );

      await controller.onClickBookItem();

      verifyNever(
        () => homeBloc.add(HomeActionsUpdatePage(bookId: 'b1', newPage: 250)),
      );
    });
  });

  test('navigate to book details', () async {
    when(() => dialogs.askForBookItemAction('title')).thenAnswer(
      (_) => Stream.value(BookItemActions.navigateToBookDetails),
    );

    await controller.onClickBookItem();

    verify(
      () => homeBloc.add(HomeActionsNavigateToBookDetails(bookId: 'b1')),
    ).called(1);
  });
}
