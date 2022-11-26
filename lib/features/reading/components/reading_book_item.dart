import 'dart:typed_data';

import 'package:app/components/book_image_component.dart';
import 'package:app/components/pages_progress_bar_component.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/extensions/book_status_extension.dart';
import 'package:app/extensions/navigator_build_context_extension.dart';
import 'package:app/features/reading/components/reading_book_item_skeleton.dart';
import 'package:flutter/material.dart';

class ReadingBookItem extends StatelessWidget {
  final Book book;

  const ReadingBookItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ReadingBookItemSkeleton(
      onPressed: () => _onPressed(context),
      imageBody: _Image(
        bookId: book.id,
        imageData: book.image?.data,
      ),
      descriptionBody: _Description(
        title: book.title,
        author: book.author,
        readPagesAmount: book.readPagesAmount,
        allPagesAmount: book.allPagesAmount,
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

    return Hero(
      tag: bookId,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BookImageComponent(
          image: image,
          bookIconSize: 48,
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const _Description({
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
