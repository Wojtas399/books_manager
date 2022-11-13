import 'dart:typed_data';

import 'package:app/components/book_image_component.dart';
import 'package:app/extensions/navigator_build_context_extension.dart';
import 'package:flutter/material.dart';

class LibraryBookItem extends StatelessWidget {
  final String bookId;
  final Uint8List? imageData;
  final String title;
  final String author;

  const LibraryBookItem({
    super.key,
    required this.bookId,
    required this.imageData,
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onPressed(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 180,
                child: _Image(bookId: bookId, imageData: imageData),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _Description(title: title, author: author),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    context.navigateToBookPreview(bookId: bookId, imageData: imageData);
  }
}

class _Image extends StatelessWidget {
  final String bookId;
  final Uint8List? imageData;

  const _Image({required this.bookId, required this.imageData});

  @override
  Widget build(BuildContext context) {
    final Uint8List? imageData = this.imageData;
    Image? image;
    if (imageData != null) {
      image = Image.memory(imageData);
    }

    return Hero(
      tag: bookId,
      child: BookImageComponent(
        image: image,
        bookIconSize: 100,
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String title;
  final String author;

  const _Description({
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(height: 4),
          Text(
            author,
            maxLines: 1,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.color
                  ?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
