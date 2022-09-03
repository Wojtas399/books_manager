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
    final Uint8List? imageData = context.select(
      (BookPreviewBloc bloc) => bloc.state.bookImageData,
    );

    return BookImageComponent(
      image: imageData != null
          ? Image.memory(
              imageData,
              fit: BoxFit.contain,
            )
          : null,
      bookIconSize: 120,
    );
  }
}