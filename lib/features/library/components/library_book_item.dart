import 'dart:typed_data';

import 'package:app/components/book_image_component.dart';
import 'package:flutter/material.dart';

class LibraryBookItem extends StatelessWidget {
  final Uint8List? imageData;
  final String title;
  final String author;
  final VoidCallback? onPressed;

  const LibraryBookItem({
    super.key,
    required this.imageData,
    required this.title,
    required this.author,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
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
                child: _Image(imageData: imageData),
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
}

class _Image extends StatelessWidget {
  final Uint8List? imageData;

  const _Image({required this.imageData});

  @override
  Widget build(BuildContext context) {
    final Uint8List? imageData = this.imageData;

    return BookImageComponent(
      image: imageData != null
          ? Image.memory(
              imageData,
              fit: BoxFit.contain,
            )
          : null,
      bookIconSize: 100,
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
            style: TextStyle(color: Colors.black.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
