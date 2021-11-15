import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/statistics/elements/books_statistics/books_statistics_controller.dart';
import 'package:app/modules/statistics/elements/books_statistics/books_status_dropdown_form_field.dart';
import 'package:app/widgets/charts/doughnut_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import '../global_mocks.dart';

void main() {
  BookQuery bookQuery = MockBookQuery();
  BookCategoryService bookCategoryService = MockBookCategoryService();
  late BooksStatisticsController controller;

  setUp(() {
    controller = BooksStatisticsController(
      bookQuery: bookQuery,
      bookCategoryService: bookCategoryService,
    );
  });

  tearDown(() {
    reset(bookQuery);
    reset(bookCategoryService);
  });

  group('common data', () {
    setUp(() {
      when(() => bookQuery.selectAllIds()).thenAnswer(
        (_) => new BehaviorSubject<List<String>>.seeded([
          'b1',
          'b2',
          'b3',
        ]),
      );
      when(() => bookQuery.selectStatus('b1')).thenAnswer(
          (_) => new BehaviorSubject<BookStatus>.seeded(BookStatus.read));
      when(() => bookQuery.selectStatus('b2')).thenAnswer(
          (_) => new BehaviorSubject<BookStatus>.seeded(BookStatus.read));
      when(() => bookQuery.selectStatus('b3')).thenAnswer(
          (_) => new BehaviorSubject<BookStatus>.seeded(BookStatus.paused));
      when(() => bookQuery.selectCategory('b1')).thenAnswer(
          (_) => new BehaviorSubject<BookCategory>.seeded(BookCategory.art));
      when(() => bookQuery.selectCategory('b2')).thenAnswer(
          (_) => new BehaviorSubject<BookCategory>.seeded(BookCategory.art));
      when(() => bookQuery.selectCategory('b3'))
          .thenAnswer((_) => new BehaviorSubject<BookCategory>.seeded(
                BookCategory.academic_books,
              ));
    });

    group('matching books', () {
      setUp(() {
        when(() => bookCategoryService.convertCategoryToText(BookCategory.art))
            .thenReturn('sztuka');
        when(() => bookCategoryService.convertCategoryToText(
            BookCategory.biography_autobiography)).thenReturn('sztuka');
        when(() => bookCategoryService.convertCategoryToText(
            BookCategory.academic_books)).thenReturn('akademickie');
      });

      group('all', () {
        group('chart data', () {
          test('should contain chart data with all books categories', () async {
            List<DoughnutChartData> data =
                await controller.categoriesData$.first;
            expect(data[0].xValue, 'sztuka');
            expect(data[0].yValue, 2);
            expect(data[0].color, '#C7E3D0');
            expect(data[1].xValue, 'akademickie');
            expect(data[1].yValue, 1);
            expect(data[1].color, '#FFDBCC');
          });
        });

        group('matching books amount', () {
          test('should contain the amount of all books', () async {
            int amount = await controller.matchingBooksAmount$.first;
            expect(amount, 3);
          });
        });
      });

      group('one of the selected books status', () {
        setUp(() {
          controller.setNewBooksStatus(StatsBooksStatus.read);
        });

        group('chart data', () {
          test(
            'should contain chart data with matching books categories',
                () async {
              List<DoughnutChartData> data =
              await controller.categoriesData$.first;
              expect(data.length, 1);
              expect(data[0].xValue, 'sztuka');
              expect(data[0].yValue, 2);
              expect(data[0].color, '#C7E3D0');
            },
          );
        });

        group('matching books amount', () {
          test('should contain the amounts of matching books', () async {
            int amount = await controller.matchingBooksAmount$.first;
            expect(amount, 2);
          });
        });
      });
    });
  });
}
