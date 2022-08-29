import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/book.dart';
import '../bloc/library_bloc.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Book> books = context.select(
      (LibraryBloc bloc) => bloc.state.books,
    );

    return GridView.count(
      crossAxisCount: 2,
      children: books.map((Book book) => _BookItem(book: book)).toList(),
    );
  }
}

class _BookItem extends StatelessWidget {
  final Book book;

  const _BookItem({required this.book});

  @override
  Widget build(BuildContext context) {
    final Uint8List? imageData = book.imageData;

    return Container(
      width: 200,
      height: 200,
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      child: imageData != null ? Image.memory(imageData) : Text(book.title),
    );
  }
}
