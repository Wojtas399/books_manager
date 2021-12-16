import 'package:app/constants/theme.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/modules/home/bloc/home_query.dart';
import 'package:app/modules/home/elements/statistics/read_books_stats_charts_controller.dart';
import 'package:app/widgets/charts/doughnut_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeQuery extends Mock implements HomeQuery {}

void main() {
  HomeQuery query = MockHomeQuery();
  late ReadBooksStatsChartsController controller;

  setUp(() {
    controller = ReadBooksStatsChartsController(homeQuery: query);
  });

  tearDown(() {});

  test(
    'categories data',
    () async {
      const List<BookCategory> categories = [
        BookCategory.art,
        BookCategory.art,
        BookCategory.horror,
      ];
      when(() => query.booksCategories$).thenAnswer(
        (_) => Stream.value(categories),
      );

      List<DoughnutChartData>? data = await controller.categoriesData$.first;

      expect(data[0].xValue, 'sztuka');
      expect(data[0].yValue, 2);
      expect(data[0].color, '#C7E3D0');
      expect(data[1].xValue, 'horror');
      expect(data[1].yValue, 1);
      expect(data[1].color, '#FEE1E8');
    },
  );

  test(
    'pages data',
    () async {
      const int readPages = 440;
      const int allPages = 850;
      when(() => query.readPages$).thenAnswer(
        (_) => Stream.value(readPages),
      );
      when(() => query.allPages$).thenAnswer(
        (_) => Stream.value(allPages),
      );

      PagesData? data = await controller.pagesData$.first;

      expect(data?.readPages.xValue, 'przeczytane');
      expect(data?.readPages.yValue, readPages);
      expect(data?.readPages.color, AppColors.DARK_BLUE);
      expect(data?.remainingPages.xValue, 'pozostałe');
      expect(data?.remainingPages.yValue, allPages - readPages);
      expect(data?.remainingPages.color, '#FFFFFF');
      expect(data?.allPages.xValue, 'wszystkie');
      expect(data?.allPages.yValue, allPages);
      expect(data?.allPages.color, '#FFFFFF');
    },
  );
}
