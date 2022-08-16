import 'package:app/core/book/book_model.dart';

class BookCategoryService {
  String convertCategoryToText(BookCategory category) {
    switch (category) {
      case BookCategory.biography_autobiography:
        return 'biografie i autobiografie';
      case BookCategory.business_economy_marketing:
        return 'biznes, ekonomia, marketing';
      case BookCategory.for_kids:
        return 'dla dzieci';
      case BookCategory.for_youth:
        return 'dla młodzieży';
      case BookCategory.fantasy:
        return 'fantasy';
      case BookCategory.history:
        return 'historia';
      case BookCategory.horror:
        return 'horror';
      case BookCategory.IT:
        return 'informatyka';
      case BookCategory.comic_book:
        return 'komiks';
      case BookCategory.detective_sensation_thriller:
        return 'kryminał, sensacja, thriller';
      case BookCategory.regional_book:
        return 'książka regionalna';
      case BookCategory.kitchen_diet:
        return 'kuchnia i diety';
      case BookCategory.reading_school_help:
        return 'lektury, pomoce szkolne';
      case BookCategory.reporting:
        return 'literatura faktu, reportaż';
      case BookCategory.moral_literature:
        return 'literatura obyczajowa';
      case BookCategory.foreign_literature:
        return 'literatura piękna obca';
      case BookCategory.polish_literature:
        return 'literatura piękna polska';
      case BookCategory.language_learning:
        return 'nauka języków';
      case BookCategory.social_human_science:
        return 'nauki społeczne i humanistyczne';
      case BookCategory.medicine_science:
        return 'nauki ścisłe i medycyna';
      case BookCategory.foreign:
        return 'obcojęzyczne';
      case BookCategory.academic_books:
        return 'podręczniki akademickie';
      case BookCategory.school_education_books:
        return 'podręczniki szkolne, edukacja';
      case BookCategory.poetry_drama:
        return 'poezja, aforyzm, dramat';
      case BookCategory.guides:
        return 'poradniki';
      case BookCategory.law:
        return 'prawo';
      case BookCategory.religion:
        return 'religie i wyznania';
      case BookCategory.personal_development:
        return 'rozwój osobisty';
      case BookCategory.science_fiction:
        return 'science fiction';
      case BookCategory.sports_rest:
        return 'sport i wypoczynek';
      case BookCategory.art:
        return 'sztuka';
      case BookCategory.traveling:
        return 'turystyka i podróże';
      case BookCategory.health_family_relationships:
        return 'zdrowie, rodzina, związki';
    }
  }

  BookCategory convertTextToCategory(String text) {
    switch (text) {
      case 'biografie i autobiografie':
        return BookCategory.biography_autobiography;
      case 'biznes, ekonomia, marketing':
        return BookCategory.business_economy_marketing;
      case 'dla dzieci':
        return BookCategory.for_kids;
      case 'dla młodzieży':
        return BookCategory.for_youth;
      case 'fantasy':
        return BookCategory.fantasy;
      case 'historia':
        return BookCategory.history;
      case 'horror':
        return BookCategory.horror;
      case 'informatyka':
        return BookCategory.IT;
      case 'komiks':
        return BookCategory.comic_book;
      case 'kryminał, sensacja, thriller':
        return BookCategory.detective_sensation_thriller;
      case 'książka regionalna':
        return BookCategory.regional_book;
      case 'kuchnia i diety':
        return BookCategory.kitchen_diet;
      case 'lektury, pomoce szkolne':
        return BookCategory.reading_school_help;
      case 'literatura faktu, reportaż':
        return BookCategory.reporting;
      case 'literatura obyczajowa':
        return BookCategory.moral_literature;
      case 'literatura piękna obca':
        return BookCategory.foreign_literature;
      case 'literatura piękna polska':
        return BookCategory.polish_literature;
      case 'nauka języków':
        return BookCategory.language_learning;
      case 'nauki społeczne i humanistyczne':
        return BookCategory.social_human_science;
      case 'nauki ścisłe i medycyna':
        return BookCategory.medicine_science;
      case 'obcojęzyczne':
        return BookCategory.foreign;
      case 'podręczniki akademickie':
        return BookCategory.academic_books;
      case 'podręczniki szkolne, edukacja':
        return BookCategory.school_education_books;
      case 'poezja, aforyzm, dramat':
        return BookCategory.poetry_drama;
      case 'poradniki':
        return BookCategory.guides;
      case 'prawo':
        return BookCategory.law;
      case 'religie i wyznania':
        return BookCategory.religion;
      case 'rozwój osobisty':
        return BookCategory.personal_development;
      case 'science fiction':
        return BookCategory.science_fiction;
      case 'sport i wypoczynek':
        return BookCategory.sports_rest;
      case 'sztuka':
        return BookCategory.art;
      case 'turystyka i podróże':
        return BookCategory.traveling;
      case 'zdrowie, rodzina, związki':
        return BookCategory.health_family_relationships;
      default:
        return BookCategory.biography_autobiography;
    }
  }
}
