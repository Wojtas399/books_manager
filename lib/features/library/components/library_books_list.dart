import 'package:app/components/animated_opacity_and_scale_component.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/features/library/components/library_book_item.dart';
import 'package:flutter/material.dart';

class LibraryBooksList extends StatelessWidget {
  final List<Book> books;

  const LibraryBooksList({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    const int itemsWidth = 200;
    const int itemsHeight = 330;
    final List<Book> sortedBooks = [...books];
    sortedBooks.sort(_compareTitlesAlphabetically);

    if (books.isEmpty) {
      return const Center(
        child: Text('Brak pasujących książek'),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (itemsWidth / itemsHeight),
      ),
      cacheExtent: 0,
      padding: const EdgeInsets.only(top: 76, left: 12, right: 12, bottom: 12),
      itemCount: sortedBooks.length,
      itemBuilder: (_, int index) {
        final Book book = sortedBooks[index];
        return AnimatedOpacityAndScaleComponent(
          child: LibraryBookItem(
            bookId: book.id,
            imageData: book.image?.data,
            title: book.title,
            author: book.author,
          ),
        );
      },
    );
  }

  int _compareTitlesAlphabetically(Book book1, Book book2) {
    return book1.title.compareTo(book2.title);
  }
}
