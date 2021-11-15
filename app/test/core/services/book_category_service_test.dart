import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  BookCategoryService service = BookCategoryService();

  group('convertCategoryToText', () {
    group('biography_autobiography', () {
      String expectedText = 'biografie i autobiografie';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.biography_autobiography);
        expect(result, expectedText);
      });
    });

    group('business_economy_marketing', () {
      String expectedText = 'biznes, ekonomia, marketing';
      test('should be "$expectedText"', () {
        String result = service
            .convertCategoryToText(BookCategory.business_economy_marketing);
        expect(result, expectedText);
      });
    });

    group('for_kids', () {
      String expectedText = 'dla dzieci';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.for_kids);
        expect(result, expectedText);
      });
    });

    group('for_youth', () {
      String expectedText = 'dla młodzieży';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.for_youth);
        expect(result, expectedText);
      });
    });

    group('fantasy', () {
      String expectedText = 'fantasy';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.fantasy);
        expect(result, expectedText);
      });
    });

    group('history', () {
      String expectedText = 'historia';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.history);
        expect(result, expectedText);
      });
    });

    group('horror', () {
      String expectedText = 'horror';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.horror);
        expect(result, expectedText);
      });
    });

    group('IT', () {
      String expectedText = 'informatyka';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.IT);
        expect(result, expectedText);
      });
    });

    group('comic_books', () {
      String expectedText = 'komiks';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.comic_book);
        expect(result, expectedText);
      });
    });

    group('detective_sensation_thriller', () {
      String expectedText = 'kryminał, sensacja, thriller';
      test('should be "$expectedText"', () {
        String result = service
            .convertCategoryToText(BookCategory.detective_sensation_thriller);
        expect(result, expectedText);
      });
    });

    group('regional_book', () {
      String expectedText = 'książka regionalna';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.regional_book);
        expect(result, expectedText);
      });
    });

    group('kitchen_diet', () {
      String expectedText = 'kuchnia i diety';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.kitchen_diet);
        expect(result, expectedText);
      });
    });

    group('reading_school_help', () {
      String expectedText = 'lektury, pomoce szkolne';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.reading_school_help);
        expect(result, expectedText);
      });
    });

    group('reporting', () {
      String expectedText = 'literatura faktu, reportaż';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.reporting);
        expect(result, expectedText);
      });
    });

    group('moral_literature', () {
      String expectedText = 'literatura obyczajowa';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.moral_literature);
        expect(result, expectedText);
      });
    });

    group('foreign_literature', () {
      String expectedText = 'literatura piękna obca';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.foreign_literature);
        expect(result, expectedText);
      });
    });

    group('polish_literature', () {
      String expectedText = 'literatura piękna polska';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.polish_literature);
        expect(result, expectedText);
      });
    });

    group('language_learning', () {
      String expectedText = 'nauka języków';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.language_learning);
        expect(result, expectedText);
      });
    });

    group('social_human_science', () {
      String expectedText = 'nauki społeczne i humanistyczne';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.social_human_science);
        expect(result, expectedText);
      });
    });

    group('medicine_science', () {
      String expectedText = 'nauki ścisłe i medycyna';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.medicine_science);
        expect(result, expectedText);
      });
    });

    group('foreign', () {
      String expectedText = 'obcojęzyczne';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.foreign);
        expect(result, expectedText);
      });
    });

    group('academic_books', () {
      String expectedText = 'podręczniki akademickie';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.academic_books);
        expect(result, expectedText);
      });
    });

    group('school_education_books', () {
      String expectedText = 'podręczniki szkolne, edukacja';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.school_education_books);
        expect(result, expectedText);
      });
    });

    group('poetry_drama', () {
      String expectedText = 'poezja, aforyzm, dramat';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.poetry_drama);
        expect(result, expectedText);
      });
    });

    group('guides', () {
      String expectedText = 'poradniki';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.guides);
        expect(result, expectedText);
      });
    });

    group('law', () {
      String expectedText = 'prawo';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.law);
        expect(result, expectedText);
      });
    });

    group('religion', () {
      String expectedText = 'religie i wyznania';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.religion);
        expect(result, expectedText);
      });
    });

    group('personal_development', () {
      String expectedText = 'rozwój osobisty';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.personal_development);
        expect(result, expectedText);
      });
    });

    group('science_fiction', () {
      String expectedText = 'science fiction';
      test('should be "$expectedText"', () {
        String result =
            service.convertCategoryToText(BookCategory.science_fiction);
        expect(result, expectedText);
      });
    });

    group('sports_rest', () {
      String expectedText = 'sport i wypoczynek';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.sports_rest);
        expect(result, expectedText);
      });
    });

    group('art', () {
      String expectedText = 'sztuka';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.art);
        expect(result, expectedText);
      });
    });

    group('traveling', () {
      String expectedText = 'turystyka i podróże';
      test('should be "$expectedText"', () {
        String result = service.convertCategoryToText(BookCategory.traveling);
        expect(result, expectedText);
      });
    });

    group('health_family_relationships', () {
      String expectedText = 'zdrowie, rodzina, związki';
      test('should be "$expectedText"', () {
        String result = service
            .convertCategoryToText(BookCategory.health_family_relationships);
        expect(result, expectedText);
      });
    });
  });

  group('convertTextToCategory', () {
    group('biografie i autobiografie', () {
      BookCategory expectedCategory = BookCategory.biography_autobiography;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('biografie i autobiografie');
        expect(result, expectedCategory);
      });
    });

    group('biznes, ekonomia, marketing', () {
      BookCategory expectedCategory = BookCategory.business_economy_marketing;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('biznes, ekonomia, marketing');
        expect(result, expectedCategory);
      });
    });

    group('dla dzieci', () {
      BookCategory expectedCategory = BookCategory.for_kids;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('dla dzieci');
        expect(result, expectedCategory);
      });
    });

    group('dla młodzieży', () {
      BookCategory expectedCategory = BookCategory.for_youth;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('dla młodzieży');
        expect(result, expectedCategory);
      });
    });

    group('fantasy', () {
      BookCategory expectedCategory = BookCategory.fantasy;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('fantasy');
        expect(result, expectedCategory);
      });
    });

    group('historia', () {
      BookCategory expectedCategory = BookCategory.history;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('historia');
        expect(result, expectedCategory);
      });
    });

    group('horror', () {
      BookCategory expectedCategory = BookCategory.horror;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('horror');
        expect(result, expectedCategory);
      });
    });

    group('informatyka', () {
      BookCategory expectedCategory = BookCategory.IT;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('informatyka');
        expect(result, expectedCategory);
      });
    });

    group('komiks', () {
      BookCategory expectedCategory = BookCategory.comic_book;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('komiks');
        expect(result, expectedCategory);
      });
    });

    group('kryminał, sensacja, thriller', () {
      BookCategory expectedCategory = BookCategory.detective_sensation_thriller;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('kryminał, sensacja, thriller');
        expect(result, expectedCategory);
      });
    });

    group('książka regionalna', () {
      BookCategory expectedCategory = BookCategory.regional_book;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('książka regionalna');
        expect(result, expectedCategory);
      });
    });

    group('kuchnia i diety', () {
      BookCategory expectedCategory = BookCategory.kitchen_diet;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('kuchnia i diety');
        expect(result, expectedCategory);
      });
    });

    group('lektury, pomoce szkolne', () {
      BookCategory expectedCategory = BookCategory.reading_school_help;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('lektury, pomoce szkolne');
        expect(result, expectedCategory);
      });
    });

    group('literatura faktu, reportaż', () {
      BookCategory expectedCategory = BookCategory.reporting;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('literatura faktu, reportaż');
        expect(result, expectedCategory);
      });
    });

    group('literatura obyczajowa', () {
      BookCategory expectedCategory = BookCategory.moral_literature;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('literatura obyczajowa');
        expect(result, expectedCategory);
      });
    });

    group('literatura piękna obca', () {
      BookCategory expectedCategory = BookCategory.foreign_literature;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('literatura piękna obca');
        expect(result, expectedCategory);
      });
    });

    group('literatura piękna polska', () {
      BookCategory expectedCategory = BookCategory.polish_literature;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('literatura piękna polska');
        expect(result, expectedCategory);
      });
    });

    group('nauka języków', () {
      BookCategory expectedCategory = BookCategory.language_learning;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('nauka języków');
        expect(result, expectedCategory);
      });
    });

    group('nauki społeczne i humanistyczne', () {
      BookCategory expectedCategory = BookCategory.social_human_science;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('nauki społeczne i humanistyczne');
        expect(result, expectedCategory);
      });
    });

    group('nauki ścisłe i medycyna', () {
      BookCategory expectedCategory = BookCategory.medicine_science;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('nauki ścisłe i medycyna');
        expect(result, expectedCategory);
      });
    });

    group('obcojęzyczne', () {
      BookCategory expectedCategory = BookCategory.foreign;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('obcojęzyczne');
        expect(result, expectedCategory);
      });
    });

    group('podręczniki akademickie', () {
      BookCategory expectedCategory = BookCategory.academic_books;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('podręczniki akademickie');
        expect(result, expectedCategory);
      });
    });

    group('podręczniki szkolne, edukacja', () {
      BookCategory expectedCategory = BookCategory.school_education_books;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('podręczniki szkolne, edukacja');
        expect(result, expectedCategory);
      });
    });

    group('poezja, aforyzm, dramat', () {
      BookCategory expectedCategory = BookCategory.poetry_drama;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('poezja, aforyzm, dramat');
        expect(result, expectedCategory);
      });
    });

    group('poradniki', () {
      BookCategory expectedCategory = BookCategory.guides;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('poradniki');
        expect(result, expectedCategory);
      });
    });

    group('prawo', () {
      BookCategory expectedCategory = BookCategory.law;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('prawo');
        expect(result, expectedCategory);
      });
    });

    group('religie i wyznania', () {
      BookCategory expectedCategory = BookCategory.religion;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('religie i wyznania');
        expect(result, expectedCategory);
      });
    });

    group('rozwój osobisty', () {
      BookCategory expectedCategory = BookCategory.personal_development;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('rozwój osobisty');
        expect(result, expectedCategory);
      });
    });

    group('science fiction', () {
      BookCategory expectedCategory = BookCategory.science_fiction;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('science fiction');
        expect(result, expectedCategory);
      });
    });

    group('sport i wypoczynek', () {
      BookCategory expectedCategory = BookCategory.sports_rest;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('sport i wypoczynek');
        expect(result, expectedCategory);
      });
    });

    group('sztuka', () {
      BookCategory expectedCategory = BookCategory.art;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('sztuka');
        expect(result, expectedCategory);
      });
    });

    group('turystyka i podróże', () {
      BookCategory expectedCategory = BookCategory.traveling;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('turystyka i podróże');
        expect(result, expectedCategory);
      });
    });

    group('zdrowie, rodzina, związki', () {
      BookCategory expectedCategory = BookCategory.health_family_relationships;
      test('should be "$expectedCategory"', () {
        BookCategory result =
            service.convertTextToCategory('zdrowie, rodzina, związki');
        expect(result, expectedCategory);
      });
    });

    group('default', () {
      BookCategory expectedCategory = BookCategory.biography_autobiography;
      test('should be "$expectedCategory"', () {
        BookCategory result = service.convertTextToCategory('asdasda');
        expect(result, expectedCategory);
      });
    });
  });
}
