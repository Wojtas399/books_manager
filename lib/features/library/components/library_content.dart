import 'package:app/domain/entities/book.dart';
import 'package:app/features/library/bloc/library_bloc.dart';
import 'package:app/features/library/components/library_book_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    const int itemsWidth = 200;
    const int itemsHeight = 315;
    final List<Book> books = context.select(
      (LibraryBloc bloc) => bloc.state.books,
    );

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (itemsWidth / itemsHeight),
      padding: const EdgeInsets.all(8),
      children: books.map(_buildBookItem).toList(),
    );
  }

  Widget _buildBookItem(Book book) {
    final String? bookId = book.id;
    if (bookId == null) {
      return const SizedBox();
    }
    return LibraryBookItem(
      imageData: book.imageData,
      title: book.title,
      author: book.author,
      onPressed: () {
        //TODO
      },
    );
  }
}
