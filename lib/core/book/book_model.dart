class Book {
  String id;
  String author;
  String title;
  BookCategory category;
  int pages;
  int readPages;
  BookStatus status;
  String imgPath;
  String imgUrl;
  String addDate;
  String lastActualisation;

  Book({
    required this.id,
    required this.author,
    required this.title,
    required this.category,
    required this.pages,
    required this.readPages,
    required this.status,
    required this.imgPath,
    required this.imgUrl,
    required this.addDate,
    required this.lastActualisation,
  });
}

enum BookStatus {
  pending,
  read,
  end,
  paused,
}

enum BookCategory {
  biography_autobiography,
  business_economy_marketing,
  for_kids,
  for_youth,
  fantasy,
  history,
  horror,
  IT,
  comic_book,
  detective_sensation_thriller,
  regional_book,
  kitchen_diet,
  reading_school_help,
  reporting,
  moral_literature,
  foreign_literature,
  polish_literature,
  language_learning,
  social_human_science,
  medicine_science,
  foreign,
  academic_books,
  school_education_books,
  poetry_drama,
  guides,
  law,
  religion,
  personal_development,
  science_fiction,
  sports_rest,
  art,
  traveling,
  health_family_relationships,
}

Book createBook({
  String? id,
  String? author,
  String? title,
  BookCategory? category,
  int? pages,
  int? readPages,
  BookStatus? status,
  String? imgPath,
  String? imgUrl,
  String? addDate,
  String? lastActualisation,
}) {
  return new Book(
    id: id ?? '',
    author: author ?? '',
    title: title ?? '',
    category: category ?? BookCategory.biography_autobiography,
    pages: pages ?? 0,
    readPages: readPages ?? 0,
    status: status ?? BookStatus.pending,
    imgPath: imgPath ?? '',
    imgUrl: imgUrl ?? '',
    addDate: addDate ?? '',
    lastActualisation: lastActualisation ?? '',
  );
}
