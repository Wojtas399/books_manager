import 'package:app/core/book/book_model.dart';
import 'package:equatable/equatable.dart';

class AddBookModel extends Equatable {
  final String title;
  final String author;
  final BookCategory category;
  final String imgPath;
  final int readPages;
  final int pages;
  final BookStatus status;

  AddBookModel({
    required this.title,
    required this.author,
    required this.category,
    required this.imgPath,
    required this.readPages,
    required this.pages,
    required this.status,
  });

  @override
  List<Object> get props => [
        title,
        author,
        category,
        imgPath,
        readPages,
        pages,
        status,
      ];
}

class AddBookFormModel {
  String title;
  String author;
  String category;
  int readPages;
  int pages;

  AddBookFormModel({
    required this.title,
    required this.author,
    required this.category,
    required this.readPages,
    required this.pages,
  });
}
