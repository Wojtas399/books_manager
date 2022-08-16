import 'package:app/core/book/book_model.dart';

const List<Category> BookCategories = [
  Category(type: BookCategory.biography_autobiography, color: '#ABDEE6'),
  Category(type: BookCategory.business_economy_marketing, color: '#CBAACB'),
  Category(type: BookCategory.for_kids, color: '#FFFFB5'),
  Category(type: BookCategory.for_youth, color: '#FFCCB6'),
  Category(type: BookCategory.fantasy, color: '#F3B0C3'),
  Category(type: BookCategory.history, color: '#C6DBDA'),
  Category(type: BookCategory.horror, color: '#FEE1E8'),
  Category(type: BookCategory.IT, color: '#FED7C3'),
  Category(type: BookCategory.comic_book, color: '#F6EAC2'),
  Category(type: BookCategory.detective_sensation_thriller, color: '#ECD5E3'),
  Category(type: BookCategory.regional_book, color: '#FF968A'),
  Category(type: BookCategory.kitchen_diet, color: '#FFAEA5'),
  Category(type: BookCategory.reading_school_help, color: '#FFC5BF'),
  Category(type: BookCategory.reporting, color: '#FFD8BE'),
  Category(type: BookCategory.moral_literature, color: '#FFC8A2'),
  Category(type: BookCategory.foreign_literature, color: '#D4F0F0'),
  Category(type: BookCategory.polish_literature, color: '#8FCACA'),
  Category(type: BookCategory.language_learning, color: '#CCE2CB'),
  Category(type: BookCategory.social_human_science, color: '#B6CDB6'),
  Category(type: BookCategory.medicine_science, color: '#97C1A9'),
  Category(type: BookCategory.foreign, color: '#FCB9AA'),
  Category(type: BookCategory.academic_books, color: '#FFDBCC'),
  Category(type: BookCategory.school_education_books, color: '#ECEAE4'),
  Category(type: BookCategory.poetry_drama, color: '#A2E1DB'),
  Category(type: BookCategory.guides, color: '#55CBCD'),
  Category(type: BookCategory.law, color: '#E0BBE4'),
  Category(type: BookCategory.religion, color: '#956DAD'),
  Category(type: BookCategory.personal_development, color: '#D291BC'),
  Category(type: BookCategory.science_fiction, color: '#FEC8D8'),
  Category(type: BookCategory.sports_rest, color: '#FFDFD3'),
  Category(type: BookCategory.art, color: '#C7E3D0'),
  Category(type: BookCategory.traveling, color: '#C9C1E7'),
  Category(type: BookCategory.health_family_relationships, color: '#BDD5EF'),
];

class Category {
  final BookCategory type;
  final String color;

  const Category({required this.type, required this.color});
}
