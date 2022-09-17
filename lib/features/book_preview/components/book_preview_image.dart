import 'dart:typed_data';

import 'package:app/components/book_image_component.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPreviewImage extends StatelessWidget {
  const BookPreviewImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.only(
        top: 24,
        right: 24,
        bottom: 16,
        left: 24,
      ),
      child: const _BookImage(),
    );
  }
}

class _BookImage extends StatelessWidget {
  const _BookImage();

  @override
  Widget build(BuildContext context) {
    final String bookId = context.select(
      (BookPreviewBloc bloc) => bloc.state.bookId,
    );
    final Uint8List? initialImageData = context.select(
      (BookPreviewBloc bloc) => bloc.state.initialBookImageData,
    );
    final Uint8List? imageData = context.select(
      (BookPreviewBloc bloc) => bloc.state.bookImageData,
    );
    Image? image;
    if (imageData != null) {
      image = Image.memory(imageData);
    } else if (initialImageData != null) {
      image = Image.memory(initialImageData);
    }

    return Hero(
      tag: bookId,
      child: BookImageComponent(
        image: image,
        bookIconSize: 120,
      ),
    );
  }
}
