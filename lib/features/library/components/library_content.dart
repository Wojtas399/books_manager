import 'package:app/components/animated_scroll_view_item_component.dart';
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
    const int itemsHeight = 330;
    final List<Book> books = context.select(
      (LibraryBloc bloc) => bloc.state.sortedBooks,
    );

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (itemsWidth / itemsHeight),
      ),
      cacheExtent: 0,
      padding: const EdgeInsets.all(12),
      itemCount: books.length,
      itemBuilder: (_, int index) {
        final Book book = books[index];
        return AnimatedScrollViewItemComponent(
          child: LibraryBookItem(
            bookId: book.id,
            imageData: book.imageData,
            title: book.title,
            author: book.author,
          ),
        );
      },
    );
  }
}
