import 'package:equatable/equatable.dart';

class BookDetailsModel extends Equatable {
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

  @override
  List<Object> get props => [
        title,
        author,
        category,
        imgUrl,
        readPages,
        pages,
        status,
        lastActualisation,
        addDate,
      ];
}

BookDetailsModel createBookDetails({
  String? title,
  String? author,
  String? category,
  String? imgUrl,
  int? readPages,
  int? pages,
  String? status,
  String? lastActualisation,
  String? addDate,
}) {
  return BookDetailsModel(
    title: title ?? '',
    author: author ?? '',
    category: category ?? '',
    imgUrl: imgUrl ?? '',
    readPages: readPages ?? 0,
    pages: pages ?? 0,
    status: status ?? '',
    lastActualisation: lastActualisation ?? '',
    addDate: addDate ?? '',
  );
}
