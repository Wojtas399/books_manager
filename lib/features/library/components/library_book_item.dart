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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => _onPressed(context),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: _Image(bookId: bookId, imageData: imageData),
            ),
            Expanded(
              child: _Description(title: title, author: author),
            ),
          ],
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
      image = Image.memory(
        imageData,
        fit: BoxFit.fill,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        shadowColor: Theme.of(context).shadowColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Hero(
          tag: bookId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BookImageComponent(
              image: image,
              bookIconSize: 100,
            ),
          ),
        ),
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
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 4, right: 12),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            author,
            maxLines: 1,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
