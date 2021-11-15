import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/modules/library/filter_dialog/filter_dialog_controller.dart';
import 'package:app/modules/library/library_screen_dialogs.dart';
import 'package:rxdart/rxdart.dart';

class LibraryScreenController {
  late List<String> _allBooksIds;
  late BookQuery _bookQuery;
  late LibraryScreenDialogs _dialogs;
  BehaviorSubject<String> _dynamicQueryValue =
      new BehaviorSubject<String>.seeded('');
  BehaviorSubject<String> _staticQueryValue =
      new BehaviorSubject<String>.seeded('');
  BehaviorSubject<FilterOptions> _filterOptions =
      new BehaviorSubject<FilterOptions>.seeded(FilterOptions());

  LibraryScreenController({
    required List<String> allBooksIds,
    required BookQuery bookQuery,
    required LibraryScreenDialogs libraryScreenDialogs,
  }) {
    _bookQuery = bookQuery;
    _allBooksIds = allBooksIds;
    _dialogs = libraryScreenDialogs;
  }

  Stream<String> get _dynamicQueryValue$ => _dynamicQueryValue.stream;

  Stream<String> get _staticQueryValue$ => _staticQueryValue.stream;

  Stream<FilterOptions> get filterOptions$ => _filterOptions.stream;

  Iterable<Stream<BookInfo>> get _allBooksInfoAsIterableStreams$ =>
      _allBooksIds.map((bookId) {
        return Rx.combineLatest5(
          _bookQuery.selectTitle(bookId),
          _bookQuery.selectAuthor(bookId),
          _bookQuery.selectStatus(bookId),
          _bookQuery.selectCategory(bookId),
          _bookQuery.selectPages(bookId),
          (
            String title,
            String author,
            BookStatus status,
            BookCategory category,
            int pages,
          ) =>
              BookInfo(
            id: bookId,
            title: title,
            author: author,
            status: status,
            category: category,
            pages: pages,
          ),
        );
      });

  Stream<List<BookInfo>> get _allBooksInfo$ => Rx.combineLatest(
        _allBooksInfoAsIterableStreams$,
        (values) => values as List<BookInfo>,
      );

  Stream<List<String>> get matchingBooksIds$ => Rx.combineLatest3(
        _allBooksInfo$,
        _staticQueryValue$,
        filterOptions$,
        (
          List<BookInfo> allBooksInfo,
          String queryValue,
          FilterOptions filterOptions,
        ) {
          return allBooksInfo
              .where((bookInfo) => _doesTitleOrAuthorContainQuery(
                    queryValue,
                    bookInfo.title,
                    bookInfo.author,
                  ))
              .where((bookInfo) => _doesBookInfoComeUpToFilterOptions(
                    bookInfo,
                    filterOptions,
                  ))
              .map((bookInfo) => bookInfo.id)
              .toList();
        },
      );

  Stream<List<BookInfo>> get matchingBooksInSearchEngine$ => Rx.combineLatest2(
        _allBooksInfo$,
        _dynamicQueryValue$,
        (List<BookInfo> allBooksInfo, String queryValue) {
          return allBooksInfo
              .where((bookInfo) => queryValue == ''
                  ? false
                  : _doesTitleOrAuthorContainQuery(
                      queryValue,
                      bookInfo.title,
                      bookInfo.author,
                    ))
              .toList();
        },
      );

  Stream<bool> get areFilterOptions$ => filterOptions$.map((filterOptions) {
        return filterOptions.statuses != null ||
            filterOptions.categories != null ||
            filterOptions.minNumberOfPages != null ||
            filterOptions.maxNumberOfPages != null;
      });

  onQueryChanged(String value) {
    _dynamicQueryValue.add(value);
    if (value == '') {
      _staticQueryValue.add(value);
    }
  }

  onQuerySubmitted(String value) {
    _staticQueryValue.add(value);
  }

  onClickFilter() async {
    FilterOptions? filterOptions = await _dialogs.askForFilterOptions(
      _filterOptions.value,
    );
    if (filterOptions != null) {
      _filterOptions.add(filterOptions);
    }
  }

  onDeleteStatus(BookStatus status) {
    FilterOptions filterOptions = _filterOptions.value;
    filterOptions.statuses?.removeWhere((element) => element == status);
    int? length = filterOptions.statuses?.length;
    if (length != null && length == 0) {
      filterOptions.statuses = null;
    }
    _filterOptions.add(filterOptions);
  }

  onDeleteCategory(BookCategory category) {
    FilterOptions filterOptions = _filterOptions.value;
    filterOptions.categories?.removeWhere((element) => element == category);
    int? length = filterOptions.categories?.length;
    if (length != null && length == 0) {
      filterOptions.categories = null;
    }
    _filterOptions.add(filterOptions);
  }

  onDeleteMinNumberOfPages() {
    FilterOptions filterOptions = _filterOptions.value;
    filterOptions.minNumberOfPages = null;
    _filterOptions.add(filterOptions);
  }

  onDeleteMaxNumberOfPages() {
    FilterOptions filterOptions = _filterOptions.value;
    filterOptions.maxNumberOfPages = null;
    _filterOptions.add(filterOptions);
  }

  bool _doesTitleOrAuthorContainQuery(
    String query,
    String title,
    String author,
  ) {
    String lowerCaseQuery = query.toLowerCase();
    String lowerCaseTitle = title.toLowerCase();
    String lowerCaseAuthor = author.toLowerCase();
    return lowerCaseTitle.contains(lowerCaseQuery) ||
        lowerCaseAuthor.contains(lowerCaseQuery);
  }

  bool _doesBookInfoComeUpToFilterOptions(
    BookInfo bookInfo,
    FilterOptions filterOptions,
  ) {
    bool? isGoodStatus = filterOptions.statuses?.contains(bookInfo.status);
    bool? isGoodCategory =
        filterOptions.categories?.contains(bookInfo.category);
    int? minNumberOfPages = filterOptions.minNumberOfPages;
    int? maxNumberOfPages = filterOptions.maxNumberOfPages;
    bool? isGoodNumberOfPages = _isGoodAmountOfPages(
      bookInfo.pages,
      minNumberOfPages,
      maxNumberOfPages,
    );
    return _doesBookHaveCorrectData(
      isGoodStatus,
      isGoodCategory,
      isGoodNumberOfPages,
    );
  }

  bool? _isGoodAmountOfPages(int bookPages, int? minNumber, int? maxNumber) {
    if (minNumber != null && maxNumber != null) {
      return bookPages >= minNumber && bookPages <= maxNumber;
    } else if (minNumber != null) {
      return bookPages >= minNumber;
    } else if (maxNumber != null) {
      return bookPages <= maxNumber;
    }
  }

  bool _doesBookHaveCorrectData(
    bool? status,
    bool? category,
    bool? numberOfPages,
  ) {
    bool haveCorrectData = true;
    if (status != null && !status) {
      haveCorrectData = false;
    }
    if (category != null && !category) {
      haveCorrectData = false;
    }
    if (numberOfPages != null && !numberOfPages) {
      haveCorrectData = false;
    }
    return haveCorrectData;
  }
}

class BookInfo {
  String id;
  String title;
  String author;
  BookStatus status;
  BookCategory category;
  int pages;

  BookInfo({
    required this.id,
    required this.title,
    required this.author,
    required this.status,
    required this.category,
    required this.pages,
  });
}
