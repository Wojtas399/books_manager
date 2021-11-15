import 'package:app/constants/theme.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/home/elements/statistics/read_books_stats_charts_controller.dart';
import 'package:app/widgets/charts/doughnut_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import '../global_mocks.dart';

void main() {
  BookQuery bookQuery = MockBookQuery();
  BookCategoryService bookCategoryService = MockBookCategoryService();
  List<String> booksIds = ['b1', 'b2', 'b3'];
  late ReadBooksStatsChartsController controller;

  setUp(() {
    controller = ReadBooksStatsChartsController(
      booksIds: booksIds,
      bookQuery: bookQuery,
    );
    controller.bookCategoryService = bookCategoryService;
  });

  tearDown(() {
    reset(bookQuery);
    reset(bookCategoryService);
  });

  group('categoriesData', () {
    setUp(() {
      when(() => bookQuery.selectCategory('b1')).thenAnswer(
          (_) => new BehaviorSubject<BookCategory>.seeded(BookCategory.art));
      when(() => bookQuery.selectCategory('b2')).thenAnswer(
          (_) => new BehaviorSubject<BookCategory>.seeded(BookCategory.art));
      when(() => bookQuery.selectCategory('b3')).thenAnswer(
          (_) => new BehaviorSubject<BookCategory>.seeded(BookCategory.horror));
      when(() => bookCategoryService.convertCategoryToText(BookCategory.art))
          .thenReturn('sztuka');
      when(() => bookCategoryService.convertCategoryToText(BookCategory.horror))
          .thenReturn('horror');
    });

    test('should create doughnut data with categories', () async {
      List<DoughnutChartData>? data = await controller.categoriesData$.first;
      expect(data?[0].xValue, 'sztuka');
      expect(data?[0].yValue, 2);
      expect(data?[0].color, '#C7E3D0');
      expect(data?[1].xValue, 'horror');
      expect(data?[1].yValue, 1);
      expect(data?[1].color, '#FEE1E8');
    });
  });

  group('pagesData', () {
    setUp(() {
      when(() => bookQuery.selectReadPages('b1'))
          .thenAnswer((_) => new BehaviorSubject<int>.seeded(20));
      when(() => bookQuery.selectReadPages('b2'))
          .thenAnswer((_) => new BehaviorSubject<int>.seeded(120));
      when(() => bookQuery.selectReadPages('b3'))
          .thenAnswer((_) => new BehaviorSubject<int>.seeded(300));
      when(() => bookQuery.selectPages('b1'))
          .thenAnswer((_) => new BehaviorSubject<int>.seeded(200));
      when(() => bookQuery.selectPages('b2'))
          .thenAnswer((_) => new BehaviorSubject<int>.seeded(150));
      when(() => bookQuery.selectPages('b3'))
          .thenAnswer((_) => new BehaviorSubject<int>.seeded(500));
    });

    test('should create pages data', () async {
      PagesData? data = await controller.pagesData$.first;
      expect(data?.readPages.xValue, 'przeczytane');
      expect(data?.readPages.yValue, 440);
      expect(data?.readPages.color, AppColors.DARK_BLUE);
      expect(data?.remainingPages.xValue, 'pozostałe');
      expect(data?.remainingPages.yValue, 410);
      expect(data?.remainingPages.color, '#FFFFFF');
      expect(data?.allPages.xValue, 'wszystkie');
      expect(data?.allPages.yValue, 850);
      expect(data?.allPages.color, '#FFFFFF');
    });
  });
}
