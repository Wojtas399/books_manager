import 'package:app/constants/book_categories.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/widgets/charts/doughnut_chart.dart';
import 'package:rxdart/rxdart.dart';
import 'books_status_dropdown_form_field.dart';

class BooksStatisticsController {
  late final BookQuery _bookQuery;
  late final BookCategoryService _bookCategoryService;
  BehaviorSubject<StatsBooksStatus> _booksStatus =
      new BehaviorSubject<StatsBooksStatus>.seeded(StatsBooksStatus.all);

  BooksStatisticsController({
    required BookQuery bookQuery,
    required BookCategoryService bookCategoryService,
  }) {
    _bookQuery = bookQuery;
    _bookCategoryService = bookCategoryService;
  }

  Stream<List<String>> get _allBooksIds$ => _bookQuery.selectAllIds();

  Stream<StatsBooksStatus> get _booksStatus$ => _booksStatus.stream;

  Stream<List<BookStatus>> get _booksStatuses$ => _allBooksIds$
      .map((ids) => ids.map((id) => _bookQuery.selectStatus(id)))
      .flatMap((statusesStreams) => Rx.combineLatest(
            statusesStreams,
            (values) => values as List<BookStatus>,
          ));

  Stream<List<BookCategory>> get _bookCategories$ => _allBooksIds$
      .map((ids) => ids.map((id) => _bookQuery.selectCategory(id)))
      .flatMap((categories) => Rx.combineLatest(
            categories,
            (values) => values as List<BookCategory>,
          ));

  Stream<List<BookCategory>> get _matchingBooksCategories$ => Rx.combineLatest3(
        _booksStatuses$,
        _bookCategories$,
        _booksStatus$,
        (
          List<BookStatus> allBooksStatuses,
          List<BookCategory> allBooksCategories,
          StatsBooksStatus booksStatus,
        ) {
          if (booksStatus == StatsBooksStatus.all) {
            return allBooksCategories;
          } else {
            List<BookCategory> categories = [];
            for (int i = 0; i < allBooksStatuses.length; i++) {
              StatsBooksStatus status =
                  _convertBookStatusIntoStatsBookStatus(allBooksStatuses[i]);
              if (status == booksStatus) {
                categories.add(allBooksCategories[i]);
              }
            }
            return categories;
          }
        },
      );

  Stream<List<DoughnutChartData>> get categoriesData$ =>
      _matchingBooksCategories$
          .map((categories) => _countCategories(categories));

  Stream<int> get matchingBooksAmount$ =>
      _matchingBooksCategories$.map((categories) => categories.length);

  setNewBooksStatus(StatsBooksStatus status) {
    _booksStatus.add(status);
  }

  List<DoughnutChartData> _countCategories(List<BookCategory> categories) {
    List<DoughnutChartData> chartData = [];
    for (BookCategory category in categories) {
      String categoryName =
          _bookCategoryService.convertCategoryToText(category);
      List<String> includedCategories =
          chartData.map((data) => data.xValue).toList();
      if (includedCategories.contains(categoryName)) {
        int idx = chartData.indexWhere((data) => data.xValue == categoryName);
        chartData[idx].yValue++;
      } else {
        int idx = BookCategories.indexWhere(
          (element) => element.type == category,
        );
        chartData.add(DoughnutChartData(
          xValue: categoryName,
          yValue: 1,
          color: BookCategories[idx].color,
        ));
      }
    }
    return chartData;
  }

  StatsBooksStatus _convertBookStatusIntoStatsBookStatus(BookStatus status) {
    switch (status) {
      case BookStatus.pending:
        return StatsBooksStatus.pending;
      case BookStatus.read:
        return StatsBooksStatus.read;
      case BookStatus.end:
        return StatsBooksStatus.end;
      case BookStatus.paused:
        return StatsBooksStatus.paused;
    }
  }
}
