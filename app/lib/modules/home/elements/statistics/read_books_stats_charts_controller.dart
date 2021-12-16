import 'package:app/constants/book_categories.dart';
import 'package:app/constants/theme.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/home/bloc/home_query.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../widgets/charts/doughnut_chart.dart';

class ReadBooksStatsChartsController {
  late HomeQuery _query;
  BookCategoryService bookCategoryService = BookCategoryService();

  ReadBooksStatsChartsController({
    required HomeQuery homeQuery,
  }) {
    _query = homeQuery;
  }

  Stream<List<DoughnutChartData>> get categoriesData$ =>
      _query.booksCategories$.map(
        (categories) => _getCategoriesData(categories),
      );

  Stream<PagesData?> get pagesData$ => Rx.combineLatest2(
        _query.readPages$,
        _query.allPages$,
        (int readPages, int allPages) => _getPagesData(readPages, allPages),
      );

  List<DoughnutChartData> _getCategoriesData(List<BookCategory> categories) {
    List<DoughnutChartData> data = [];
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

  PagesData? _getPagesData(int readPages, int allPages) {
    if (readPages > 0 && allPages > 0) {
      return PagesData(
        readPages: DoughnutChartData(
          xValue: 'przeczytane',
          yValue: readPages,
          color: AppColors.DARK_BLUE,
        ),
        remainingPages: DoughnutChartData(
          xValue: 'pozostałe',
          yValue: allPages - readPages,
          color: '#FFFFFF',
        ),
        allPages: DoughnutChartData(
          xValue: 'wszystkie',
          yValue: allPages,
          color: '#FFFFFF',
        ),
      );
    }
    return null;
  }
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
