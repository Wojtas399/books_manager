import 'package:app/core/book/book_model.dart';
import 'package:equatable/equatable.dart';

class BookDetailsEditModel extends Equatable {
  final String title;
  final String author;
  final BookCategory category;
  final int readPages;
  final int pages;

  BookDetailsEditModel({
    required this.title,
    required this.author,
    required this.category,
    required this.readPages,
    required this.pages,
  });

  @override
  List<Object> get props => [title, author, category, readPages, pages];
}

class BookDetailsEditedDataModel extends Equatable {
  String? title;
  String? author;
  BookCategory? category;
  int? readPages;
  int? pages;

  BookDetailsEditedDataModel({
    this.title,
    this.author,
    this.category,
    this.readPages,
    this.pages,
  });

  @override
  List<Object> get props => [
        title ?? '',
        author ?? '',
        category ?? '',
        readPages ?? '',
        pages ?? '',
      ];
}

BookDetailsEditModel createBookDetailsEdit({
  String? title,
  String? author,
  BookCategory? category,
  int? readPages,
  int? pages,
}) {
  return BookDetailsEditModel(
    title: title ?? '',
    author: author ?? '',
    category: category ?? BookCategory.biography_autobiography,
    readPages: readPages ?? 0,
    pages: pages ?? 0,
  );
}

BookDetailsEditedDataModel createBookDetailsEditedData({
  String? title,
  String? author,
  BookCategory? category,
  int? readPages,
  int? pages,
}) {
  return BookDetailsEditedDataModel(
    title: title,
    author: author,
    category: category,
    readPages: readPages,
    pages: pages,
  );
}
