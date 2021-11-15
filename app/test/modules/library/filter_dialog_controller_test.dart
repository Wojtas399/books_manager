import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/library/filter_dialog/filter_dialog_controller.dart';
import 'package:app/modules/library/library_screen_book_status_service.dart';
import 'package:app/modules/library/library_screen_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../global_mocks.dart';
import 'library_mocks.dart';

void main() {
  BookCategoryService bookCategoryService = MockBookCategoryService();
  LibraryScreenDialogs libraryScreenDialogs = MockLibraryScreenDialogs();
  FilterOptions filterOptions = FilterOptions(
    statuses: [BookStatus.read],
    categories: [BookCategory.art],
    minNumberOfPages: 100,
    maxNumberOfPages: 500,
  );
  LibraryScreenBookStatusService libraryScreenBookStatusService =
      MockLibraryScreenBookStatusService();
  late FilterDialogController controller;

  setUp(() {
    when(() => libraryScreenBookStatusService.convertBookStatusStringToEnum(
          'czytane'
        )).thenReturn(BookStatus.read);
    when(() => libraryScreenBookStatusService.convertBookStatusStringToEnum(
          'przeczytane',
        )).thenReturn(BookStatus.end);
    when(() => libraryScreenBookStatusService.convertBookStatusStringToEnum(
          'nieprzeczytane',
        )).thenReturn(BookStatus.pending);
    when(() => libraryScreenBookStatusService.convertBookStatusStringToEnum(
          'wstrzymane',
        )).thenReturn(BookStatus.paused);
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.biography_autobiography
        )).thenReturn('biografie i autobiografie');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.business_economy_marketing,
        )).thenReturn('biznes, ekonomia, marketing');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.for_kids,
        )).thenReturn('dla dzieci');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.for_youth,
        )).thenReturn('dla młodzieży');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.fantasy,
        )).thenReturn('fantasy');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.history,
        )).thenReturn('historia');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.horror,
        )).thenReturn('horror');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.IT,
        )).thenReturn('informatyka');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.comic_book,
        )).thenReturn('komiks');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.detective_sensation_thriller,
        )).thenReturn('kryminał, sensacja, thriller');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.regional_book,
        )).thenReturn('książka regionalna');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.kitchen_diet,
        )).thenReturn('kuchnia i diety');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.reading_school_help,
        )).thenReturn('lektyr, pomoce szkolne');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.reporting,
        )).thenReturn('literatura faktu, reportaż');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.moral_literature,
        )).thenReturn('literatura obyczajowa');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.foreign_literature,
        )).thenReturn('literatura piękna obca');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.polish_literature,
        )).thenReturn('literatura piękna polska');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.language_learning,
        )).thenReturn('nauka języków');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.social_human_science,
        )).thenReturn('nauki społeczne i humanistyczne');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.medicine_science,
        )).thenReturn('nauki ścisłe i medycyna');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.foreign,
        )).thenReturn('obcojęzyczne');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.academic_books,
        )).thenReturn('podręczniki akademickie');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.school_education_books,
        )).thenReturn('podręczniki szkolne, edukacja');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.poetry_drama,
        )).thenReturn('poezja, aforyzm, dramat');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.guides,
        )).thenReturn('poradniki');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.law,
        )).thenReturn('prawo');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.religion,
        )).thenReturn('religie i wyznania');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.personal_development,
        )).thenReturn('rozwój osobisty');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.science_fiction,
        )).thenReturn('science fiction');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.sports_rest,
        )).thenReturn('sport i wypoczynek');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.art,
        )).thenReturn('sztuka');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.traveling,
        )).thenReturn('turystyka i podróże');
    when(() => bookCategoryService.convertCategoryToText(
          BookCategory.health_family_relationships,
        )).thenReturn('zdrowie, rodzina, związki');
    controller = FilterDialogController(
      bookCategoryService: bookCategoryService,
      libraryScreenDialogs: libraryScreenDialogs,
      filterOptions: filterOptions,
      libraryScreenBookStatusService: libraryScreenBookStatusService,
    );
  });

  tearDown(() {
    reset(bookCategoryService);
    reset(libraryScreenDialogs);
    reset(libraryScreenBookStatusService);
  });

  group('statuses', () {
    test('should contain statuses checkboxes props', () async {
      List<CheckboxProps> statuses = await controller.statuses$.first;
      expect(statuses[0].name, 'czytane');
      expect(statuses[0].checked, true);
      expect(statuses[3].name, 'wstrzymane');
      expect(statuses[3].checked, false);
    });
  });

  group('categories', () {
    test('should contain categories checkboxes props', () async {
      List<CheckboxProps> categories = await controller.categories$.first;
      expect(categories[30].name, 'sztuka');
      expect(categories[30].checked, true);
      expect(categories[0].name, 'biografie i autobiografie');
      expect(categories[0].checked, false);
    });
  });

  group('on change status checkbox', () {
    setUp(() {
      controller.onChangeStatusCheckbox('wstrzymane', true);
    });

    test('should change status checkbox value', () async {
      List<CheckboxProps> statuses = await controller.statuses$.first;
      expect(statuses[3].checked, true);
    });
  });

  group('on change category checkbox', () {
    setUp(() {
      controller.onChangeCategoryCheckbox('biografie i autobiografie', true);
    });

    test('should change category checkbox value', () async {
      List<CheckboxProps> categories = await controller.categories$.first;
      expect(categories[0].checked, true);
    });
  });

  group('get filter options', () {
    setUp(() {
      when(() => bookCategoryService.convertTextToCategory('sztuka'))
          .thenReturn(BookCategory.art);
    });

    group('wrong pages', () {
      setUp(() {
        when(() => libraryScreenDialogs.showWrongPagesInfo()).thenReturn(null);
      });

      group('min number of pages is higher than max number of pages', () {
        setUp(() {
          controller.minNumberOfPagesController.text = '400';
          controller.maxNumberOfPagesController.text = '100';
          controller.getFilterOptions();
        });

        test('should show warning dialog', () {
          verify(() => libraryScreenDialogs.showWrongPagesInfo()).called(1);
        });
      });

      group('min number of pages is lower than 0', () {
        setUp(() {
          controller.minNumberOfPagesController.text = '-1';
          controller.getFilterOptions();
        });

        test('should show warning dialog', () {
          verify(() => libraryScreenDialogs.showWrongPagesInfo()).called(1);
        });
      });

      group('max number of pages is lower than 0', () {
        setUp(() {
          controller.maxNumberOfPagesController.text = '-1';
          controller.getFilterOptions();
        });

        test('should show warning dialog', () {
          verify(() => libraryScreenDialogs.showWrongPagesInfo()).called(1);
        });
      });
    });

    group('correct pages', () {
      setUp(() {
        controller.onChangeStatusCheckbox('przeczytane', true);
        controller.onChangeCategoryCheckbox('sztuka', false);
        controller.minNumberOfPagesController.text = '100';
        controller.maxNumberOfPagesController.text = '500';
      });

      test('should return filter options', () {
        FilterOptions? filterOptions = controller.getFilterOptions();
        expect(filterOptions?.statuses, [BookStatus.read, BookStatus.end]);
        expect(filterOptions?.categories, null);
        expect(filterOptions?.minNumberOfPages, 100);
        expect(filterOptions?.maxNumberOfPages, 500);
      });
    });
  });
}
