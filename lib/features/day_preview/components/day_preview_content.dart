import 'package:app/components/custom_scaffold_component.dart';
import 'package:app/components/empty_content_info_component.dart';
import 'package:app/extensions/date_extensions.dart';
import 'package:app/features/day_preview/bloc/day_preview_bloc.dart';
import 'package:app/features/day_preview/components/day_preview_book_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DayPreviewContent extends StatelessWidget {
  const DayPreviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (DayPreviewBloc bloc) => bloc.state.date,
    );

    return CustomScaffold(
      appBarTitle: 'Podgląd dnia ${date?.toUIFormat() ?? ''}',
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: _ReadBooksList(),
      ),
    );
  }
}

class _ReadBooksList extends StatelessWidget {
  const _ReadBooksList();

  @override
  Widget build(BuildContext context) {
    final List<DayPreviewBook> dayPreviewBooks = context.select(
      (DayPreviewBloc bloc) => bloc.state.dayPreviewBooks,
    );

    return dayPreviewBooks.isNotEmpty
        ? ListView.builder(
            itemCount: dayPreviewBooks.length,
            itemBuilder: (_, int index) {
              return DayPreviewBookItem(
                dayPreviewBook: dayPreviewBooks[index],
              );
            },
          )
        : const _NoReadBooksInfo();
  }
}

class _NoReadBooksInfo extends StatelessWidget {
  const _NoReadBooksInfo();

  @override
  Widget build(BuildContext context) {
    return const EmptyContentInfoComponent(
      icon: MdiIcons.bookOpenPageVariant,
      title: 'Brak czytanych książek',
      subtitle: 'W tym dniu nie czytałeś żadnych książek',
    );
  }
}
