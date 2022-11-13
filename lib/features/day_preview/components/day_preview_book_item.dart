import 'package:app/components/animated_opacity_and_scale_component.dart';
import 'package:app/features/day_preview/bloc/day_preview_bloc.dart';
import 'package:flutter/material.dart';

class DayPreviewBookItem extends StatelessWidget {
  final DayPreviewBook dayPreviewBook;

  const DayPreviewBookItem({super.key, required this.dayPreviewBook});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacityAndScaleComponent(
      child: SizedBox(
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _TitleAndAuthor(
                    title: dayPreviewBook.title,
                    author: dayPreviewBook.author,
                  ),
                ),
                const VerticalDivider(thickness: 1),
                _ReadPagesAmount(
                  readPagesAmount: dayPreviewBook.amountOfPagesReadInThisDay,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleAndAuthor extends StatelessWidget {
  final String title;
  final String author;

  const _TitleAndAuthor({
    required this.title,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 4),
        Text(
          author,
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyText1?.color?.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class _ReadPagesAmount extends StatelessWidget {
  final int readPagesAmount;

  const _ReadPagesAmount({required this.readPagesAmount});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Przeczytane strony:',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Text(
          '$readPagesAmount',
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }
}
