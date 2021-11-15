class BookDetailsModel {
  final String title;
  final String author;
  final String category;
  final String imgUrl;
  final int readPages;
  final int pages;
  final String status;
  final String lastActualisation;
  final String addDate;

  BookDetailsModel({
    required this.title,
    required this.author,
    required this.category,
    required this.imgUrl,
    required this.readPages,
    required this.pages,
    required this.status,
    required this.lastActualisation,
    required this.addDate,
  });
}
