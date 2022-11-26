import 'dart:typed_data';

import 'package:app/components/book_image_component.dart';
import 'package:app/components/pages_progress_bar_component.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/extensions/book_status_extension.dart';
import 'package:app/extensions/navigator_build_context_extension.dart';
import 'package:flutter/material.dart';

class ReadingBookItem extends StatelessWidget {
  final Book book;

  const ReadingBookItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onPressed(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            _Image(
              bookId: book.id,
              imageData: book.image?.data,
            ),
            Expanded(
              child: _Info(
                title: book.title,
                author: book.author,
                readPagesAmount: book.readPagesAmount,
                allPagesAmount: book.allPagesAmount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    context.navigateToBookPreview(
      bookId: book.id,
      imageData: book.image?.data,
    );
  }
}

class _Image extends StatelessWidget {
  final String bookId;
  final Uint8List? imageData;

  const _Image({
    required this.bookId,
    required this.imageData,
  });

  @override
  Widget build(BuildContext context) {
    final Uint8List? imageData = this.imageData;
    Image? image;
    if (imageData != null) {
      image = Image.memory(
        imageData,
        fit: BoxFit.fill,
      );
    }

    return SizedBox(
      width: 120,
      child: Material(
        shadowColor: Theme.of(context).shadowColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Hero(
          tag: bookId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BookImageComponent(
              image: image,
              bookIconSize: 48,
            ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const _Info({
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TitleAndAuthor(
                title: title,
                author: author,
              ),
              const SizedBox(height: 16),
              _Pages(
                readPagesAmount: readPagesAmount,
                allPagesAmount: allPagesAmount,
              ),
            ],
          ),
        ),
      ),
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
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          author,
          maxLines: 1,
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.6),
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
