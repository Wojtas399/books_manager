import 'package:app/constants/book_categories.dart';
import 'package:app/constants/theme.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../widgets/charts/doughnut_chart.dart';

class ReadBooksStatsChartsController {
  late List<String> _booksIds;
  late BookQuery _bookQuery;
  BookCategoryService bookCategoryService = BookCategoryService();

  ReadBooksStatsChartsController({
    required List<String> booksIds,
    required BookQuery bookQuery,
  }) {
    _booksIds = booksIds;
    _bookQuery = bookQuery;
  }

  Iterable<Stream<BookCategory>> get _booksCategoriesStreams =>
      _booksIds.map((bookId) => _bookQuery.selectCategory(bookId));

  Iterable<Stream<int>> get _booksReadPagesStreams =>
      _booksIds.map((bookId) => _bookQuery.selectReadPages(bookId));

  Iterable<Stream<int>> get _booksAllPagesStreams =>
      _booksIds.map((bookId) => _bookQuery.selectPages(bookId));

  Stream<List<BookCategory>> get _booksCategories$ => Rx.combineLatest(
        _booksCategoriesStreams,
        (values) => values as List<BookCategory>,
      );

  Stream<List<int>> get _booksReadPages$ => Rx.combineLatest(
        _booksReadPagesStreams,
        (values) => values as List<int>,
      );

  Stream<List<int>> get _booksAllPages$ => Rx.combineLatest(
        _booksAllPagesStreams,
        (values) => values as List<int>,
      );

  Stream<List<DoughnutChartData>?> get categoriesData$ =>
      _booksCategories$.map((categories) {
        List<DoughnutChartData> data = [];
        if (categories.length > 0) {
          List<String> addedCategories = [];
          for (BookCategory category in categories) {
            String categoryName = bookCategoryService.convertCategoryToText(
              category,
            );
            if (addedCategories.contains(categoryName)) {
              int idx = data.indexWhere(
                (element) => element.xValue == categoryName,
              );
              data[idx].yValue++;
            } else {
              int idx = BookCategories.indexWhere(
                (element) => element.type == category,
              );
              data.add(
                DoughnutChartData(
                  xValue: categoryName,
                  yValue: 1,
                  color: BookCategories[idx].color,
                ),
              );
              addedCategories.add(categoryName);
            }
          }
          return data;
        }
      });

  Stream<PagesData?> get pagesData$ => Rx.combineLatest2(
        _booksReadPages$,
        _booksAllPages$,
        (List<int> readPages, List<int> allPages) {
          PagesData? data;
          if (readPages.length > 0 && allPages.length > 0) {
            DoughnutChartData readPagesData = DoughnutChartData(
              xValue: 'przeczytane',
              yValue: 0,
              color: AppColors.DARK_BLUE,
            );
            DoughnutChartData remainingPagesData = DoughnutChartData(
              xValue: 'pozostałe',
              yValue: 0,
              color: '#FFFFFF',
            );
            DoughnutChartData allPagesData = DoughnutChartData(
              xValue: 'wszystkie',
              yValue: 0,
              color: '#FFFFFF',
            );
            for (int number in readPages) {
              readPagesData.yValue += number;
            }
            for (int number in allPages) {
              allPagesData.yValue += number;
            }
            remainingPagesData.yValue =
                allPagesData.yValue - readPagesData.yValue;
            data = PagesData(
              readPages: readPagesData,
              remainingPages: remainingPagesData,
              allPages: allPagesData,
            );
          }
          return data;
        },
      );
}

class PagesData {
  DoughnutChartData readPages;
  DoughnutChartData remainingPages;
  DoughnutChartData allPages;

  PagesData({
    required this.readPages,
    required this.remainingPages,
    required this.allPages,
  });
}
