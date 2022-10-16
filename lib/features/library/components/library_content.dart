import 'package:app/components/empty_content_info_component.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/features/library/bloc/library_bloc.dart';
import 'package:app/features/library/components/library_books_list.dart';
import 'package:app/features/library/components/library_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Book>? books = context.select(
      (LibraryBloc bloc) => bloc.state.sortedBooks,
    );

    if (books == null) {
      return const SizedBox();
    } else if (books.isEmpty) {
      return const _EmptyContentInfo();
    }
    return Stack(
      children: [
        LibraryBooksList(books: books),
        const LibrarySearchField(),
      ],
    );
  }
}

class _EmptyContentInfo extends StatelessWidget {
  const _EmptyContentInfo();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: EmptyContentInfoComponent(
        icon: MdiIcons.bookshelf,
        title: 'Brak książek',
        subtitle: 'Aktualnie nie posiadasz żadnych książek w bibliotece',
      ),
    );
  }
}
