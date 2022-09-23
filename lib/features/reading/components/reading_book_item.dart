import 'dart:typed_data';

import 'package:app/components/book_image_component.dart';
import 'package:app/components/pages_progress_bar_component.dart';
import 'package:app/config/navigation.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/extensions/book_status_extensions.dart';
import 'package:flutter/material.dart';

class ReadingBookItem extends StatelessWidget {
  final Book book;

  const ReadingBookItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Container(
        height: 150,
        margin: const EdgeInsets.only(bottom: 4),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _BookImage(bookId: book.id, imageData: book.imageData),
                const SizedBox(width: 16),
                Expanded(
                  child: _BookInfo(
                    title: book.title,
                    author: book.author,
                    readPagesAmount: book.readPagesAmount,
                    allPagesAmount: book.allPagesAmount,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed() {
    Navigation.navigateToBookPreview(
      bookId: book.id,
      imageData: book.imageData,
    );
  }
}

class _BookImage extends StatelessWidget {
  final String bookId;
  final Uint8List? imageData;

  const _BookImage({required this.bookId, required this.imageData});

  @override
  Widget build(BuildContext context) {
    final Uint8List? imageData = this.imageData;
    Image? image;
    if (imageData != null) {
      image = Image.memory(imageData);
    }

    return Hero(
      tag: bookId,
      child: BookImageComponent(image: image),
    );
  }
}

class _BookInfo extends StatelessWidget {
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const _BookInfo({
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _TitleAndAuthor(title: title, author: author),
        ),
        Expanded(
          child: _Pages(
            readPagesAmount: readPagesAmount,
            allPagesAmount: allPagesAmount,
          ),
        ),
      ],
    );
  }
}

class _TitleAndAuthor extends StatelessWidget {
  final String title;
  final String author;

  const _TitleAndAuthor({required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          style: Theme.of(context).textTheme.subtitle1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          author,
          maxLines: 1,
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

class _Pages extends StatelessWidget {
  final int readPagesAmount;
  final int allPagesAmount;

  const _Pages({
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PagesProgressBarComponent(
        readPagesAmount: readPagesAmount,
        allPagesAmount: allPagesAmount,
        height: 20,
        borderRadius: 6,
        fontSize: 12,
        progressBarColor: BookStatus.inProgress.toColor(),
      ),
    );
  }
}
