import 'package:app/core/book/book_model.dart';
import 'package:app/modules/library/filter_dialog/filter_dialog_controller.dart';
import 'package:app/modules/library/bloc/library_query.dart';
import 'package:app/modules/library/library_dialogs.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

class LibraryController {
  late LibraryQuery _libraryQuery;
  late LibraryDialogs _dialogs;
  BehaviorSubject<String> _dynamicQueryValue =
      new BehaviorSubject<String>.seeded('');
  BehaviorSubject<String> _staticQueryValue =
      new BehaviorSubject<String>.seeded('');
  BehaviorSubject<FilterOptions> _filterOptions =
      new BehaviorSubject<FilterOptions>.seeded(FilterOptions());

  LibraryController({
    required LibraryQuery libraryQuery,
    required LibraryDialogs libraryScreenDialogs,
  }) {
    _libraryQuery = libraryQuery;
    _dialogs = libraryScreenDialogs;
  }

  Stream<String> get _dynamicQueryValue$ => _dynamicQueryValue.stream;

  Stream<String> get _staticQueryValue$ => _staticQueryValue.stream;

  Stream<FilterOptions> get filterOptions$ => _filterOptions.stream;

  Stream<List<String>> get matchingBooksIds$ => Rx.combineLatest3(
        _libraryQuery.allBooksInfo$,
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
        _libraryQuery.allBooksInfo$,
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

class BookInfo extends Equatable {
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

  @override
  List<Object> get props => [
        id,
        title,
        author,
        status,
        category,
        pages,
      ];
}
