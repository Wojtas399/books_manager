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

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (itemsWidth / itemsHeight),
      ),
      cacheExtent: 0,
      padding: const EdgeInsets.only(top: 60, left: 12, right: 12, bottom: 12),
      itemCount: books.length,
      itemBuilder: (_, int index) {
        final Book book = books[index];
        return AnimatedOpacityAndScaleComponent(
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
