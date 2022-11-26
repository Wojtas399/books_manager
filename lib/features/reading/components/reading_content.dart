import 'package:app/components/animated_opacity_and_scale_component.dart';
import 'package:app/components/empty_content_info_component.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/features/reading/bloc/reading_bloc.dart';
import 'package:app/features/reading/components/reading_book_item.dart';
import 'package:app/features/reading/components/reading_shimmer_loading.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ReadingContent extends StatelessWidget {
  const ReadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Book>? booksInProgress = context.select(
      (ReadingBloc bloc) => bloc.state.booksInProgress,
    );

    if (booksInProgress == null) {
      return const ReadingShimmerLoading();
    } else if (booksInProgress.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: EmptyContentInfoComponent(
          icon: MdiIcons.bookOpen,
          title: 'Brak czytanych książek',
          subtitle: 'Aktualnie nie czytasz żadnych książek',
        ),
      );
    }
    return ListView.builder(
      cacheExtent: 0,
      itemCount: booksInProgress.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (_, int index) {
        return AnimatedOpacityAndScaleComponent(
          child: ReadingBookItem(
            book: booksInProgress[index],
          ),
        );
      },
    );
  }
}
