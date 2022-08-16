import 'package:app/core/book/book_model.dart';
import 'package:app/modules/library/bloc/library_query.dart';
import 'package:app/modules/library/filter_dialog/filter_dialog_controller.dart';
import 'package:app/modules/library/library_controller.dart';
import 'package:app/modules/library/library_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLibraryQuery extends Mock implements LibraryQuery {}

class MockLibraryDialogs extends Mock implements LibraryDialogs {}

void main() {
  LibraryQuery libraryQuery = MockLibraryQuery();
  LibraryDialogs libraryScreenDialogs = MockLibraryDialogs();
  late LibraryController controller;
  List<BookInfo> fakeBooksInfo = [
    BookInfo(
      id: 'b1',
      title: 'title first',
      author: 'first author',
      status: BookStatus.read,
      category: BookCategory.for_kids,
      pages: 500,
    ),
    BookInfo(
      id: 'b2',
      title: 'title second',
      author: 'second author',
      status: BookStatus.end,
      category: BookCategory.art,
      pages: 250,
    ),
  ];

  setUp(() {
    controller = LibraryController(
      libraryQuery: libraryQuery,
      libraryScreenDialogs: libraryScreenDialogs,
    );
    when(() => libraryQuery.allBooksInfo$)
        .thenAnswer((_) => Stream.value(fakeBooksInfo));
  });

  tearDown(() {
    reset(libraryQuery);
    reset(libraryScreenDialogs);
  });

  group('filter options', () {
    group('default', () {
      test('all filter options should be null', () async {
        FilterOptions filterOptions = await controller.filterOptions$.first;
        expect(filterOptions.statuses, null);
        expect(filterOptions.categories, null);
        expect(filterOptions.minNumberOfPages, null);
        expect(filterOptions.maxNumberOfPages, null);
      });
    });

    group('updated', () {
      setUp(() async {
        when(() => libraryScreenDialogs.askForFilterOptions(FilterOptions()))
            .thenAnswer((_) async => FilterOptions(
                  statuses: [BookStatus.read],
                  minNumberOfPages: 100,
                ));
        await controller.onClickFilter();
      });

      test('should contain filter options', () async {
        FilterOptions filterOptions = await controller.filterOptions$.first;
        expect(filterOptions.statuses, [BookStatus.read]);
        expect(filterOptions.minNumberOfPages, 100);
      });
    });
  });

  group('matching books ids', () {
    group('default', () {
      test('should contain ids of all books', () async {
        List<String> booksIds = await controller.matchingBooksIds$.first;
        expect(booksIds, ['b1', 'b2']);
      });
    });

    group('with query', () {
      setUp(() {
        controller.onQuerySubmitted('first');
      });

      test(
        'should contain books ids which author or title matches the query',
        () async {
          List<String> booksIds = await controller.matchingBooksIds$.first;
          expect(booksIds, ['b1']);
        },
      );
    });

    group('with filter options', () {
      setUp(() async {
        when(() => libraryScreenDialogs.askForFilterOptions(FilterOptions()))
            .thenAnswer((_) async => FilterOptions(
                  statuses: [BookStatus.end],
                  categories: [BookCategory.art],
                ));
        controller.onQueryChanged('');
        await controller.onClickFilter();
      });

      test(
        'should contain books ids which data match the filter options',
        () async {
          List<String> booksIds = await controller.matchingBooksIds$.first;
          expect(booksIds, ['b2']);
        },
      );
    });
  });

  group('matching books in search engine', () {
    group('default', () {
      test('should be empty array', () async {
        List<BookInfo> books =
            await controller.matchingBooksInSearchEngine$.first;
        expect(books, []);
      });
    });

    group('with query', () {
      setUp(() {
        controller.onQueryChanged('first');
      });

      test(
        'should contain books which author or title match the query',
        () async {
          List<BookInfo> books =
              await controller.matchingBooksInSearchEngine$.first;
          expect(books[0].title, 'title first');
        },
      );
    });
  });

  group('are filter options', () {
    group('no one filter is set', () {
      test('should be false', () async {
        bool areFilterOptions = await controller.areFilterOptions$.first;
        expect(areFilterOptions, false);
      });
    });

    group('some filters are set', () {
      setUp(() async {
        when(() => libraryScreenDialogs.askForFilterOptions(FilterOptions()))
            .thenAnswer((_) async => FilterOptions(
                  statuses: [BookStatus.read],
                ));
        await controller.onClickFilter();
      });

      test('should be true', () async {
        bool areFilterOptions = await controller.areFilterOptions$.first;
        expect(areFilterOptions, true);
      });
    });
  });

  group('on click filter', () {
    group('some filters were set', () {
      setUp(() async {
        when(() => libraryScreenDialogs.askForFilterOptions(FilterOptions()))
            .thenAnswer((_) async => FilterOptions(
                  statuses: [BookStatus.read],
                  categories: [BookCategory.art, BookCategory.academic_books],
                  minNumberOfPages: 100,
                  maxNumberOfPages: 500,
                ));
        await controller.onClickFilter();
      });

      test('should set filter options', () async {
        FilterOptions filterOptions = await controller.filterOptions$.first;
        expect(filterOptions.statuses, [BookStatus.read]);
        expect(filterOptions.categories, [
          BookCategory.art,
          BookCategory.academic_books,
        ]);
        expect(filterOptions.minNumberOfPages, 100);
        expect(filterOptions.maxNumberOfPages, 500);
      });
    });

    group('no one filter was set', () {
      setUp(() async {
        when(() => libraryScreenDialogs.askForFilterOptions(FilterOptions()))
            .thenAnswer((_) async => null);
        await controller.onClickFilter();
      });

      test('should not set filters', () async {
        FilterOptions filterOptions = await controller.filterOptions$.first;
        expect(filterOptions, FilterOptions());
      });
    });
  });

  group('on delete status', () {
    group('empty array after delete', () {
      setUp(() async {
        when(() => libraryScreenDialogs.askForFilterOptions(FilterOptions()))
            .thenAnswer((_) async => FilterOptions(
                  statuses: [BookStatus.read],
                ));
        await controller.onClickFilter();
        controller.onDeleteStatus(BookStatus.read);
      });

      test('should set statuses to null', () async {
        FilterOptions filterOptions = await controller.filterOptions$.first;
        expect(filterOptions.statuses, null);
      });
    });

    group('not empty array after delete', () {
      setUp(() async {
        when(() => libraryScreenDialogs.askForFilterOptions(FilterOptions()))
            .thenAnswer((_) async => FilterOptions(
                  statuses: [BookStatus.read, BookStatus.end],
                ));
        await controller.onClickFilter();
        controller.onDeleteStatus(BookStatus.read);
      });

      test('should delete status', () async {
        FilterOptions filterOptions = await controller.filterOptions$.first;
        expect(filterOptions.statuses, [BookStatus.end]);
      });
    });
  });

  group('on delete category', () {
    group('empty array after delete', () {
      setUp(() async {
        when(() => libraryScreenDialogs.askForFilterOptions(FilterOptions()))
            .thenAnswer((_) async => FilterOptions(
                  categories: [BookCategory.art],
                ));
        await controller.onClickFilter();
        controller.onDeleteCategory(BookCategory.art);
      });

      test('should set categories to null', () async {
        FilterOptions filterOptions = await controller.filterOptions$.first;
        expect(filterOptions.categories, null);
      });
    });

    group('not empty array after delete', () {
      setUp(() async {
        when(() => libraryScreenDialogs.askForFilterOptions(FilterOptions()))
            .thenAnswer((_) async => FilterOptions(
                  categories: [
                    BookCategory.art,
                    BookCategory.academic_books,
                  ],
                ));
        await controller.onClickFilter();
        controller.onDeleteCategory(BookCategory.academic_books);
      });

      test('should delete category', () async {
        FilterOptions filterOptions = await controller.filterOptions$.first;
        expect(filterOptions.categories, [BookCategory.art]);
      });
    });
  });

  group('on delete min number of pages', () {
    setUp(() async {
      when(() => libraryScreenDialogs.askForFilterOptions(FilterOptions()))
          .thenAnswer((_) async => FilterOptions(minNumberOfPages: 100));
      await controller.onClickFilter();
      controller.onDeleteMinNumberOfPages();
    });

    test('should delete min number of pages', () async {
      FilterOptions filterOptions = await controller.filterOptions$.first;
      expect(filterOptions.minNumberOfPages, null);
    });
  });

  group('on delete max number of pages', () {
    setUp(() async {
      when(() => libraryScreenDialogs.askForFilterOptions(FilterOptions()))
          .thenAnswer((_) async => FilterOptions(maxNumberOfPages: 500));
      await controller.onClickFilter();
      controller.onDeleteMaxNumberOfPages();
    });

    test('should delete max number of pages', () async {
      FilterOptions filterOptions = await controller.filterOptions$.first;
      expect(filterOptions.maxNumberOfPages, null);
    });
  });
}
