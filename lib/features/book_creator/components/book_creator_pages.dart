import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extensions/string_extensions.dart';
import '../../../interfaces/dialog_interface.dart';
import '../../../utils/utils.dart';
import '../bloc/book_creator_bloc.dart';

class BookCreatorPages extends StatelessWidget {
  const BookCreatorPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Liczba stron',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const SizedBox(height: 16),
        IntrinsicHeight(
          child: Row(
            children: [
              const Expanded(
                child: _ReadPagesAmount(),
              ),
              VerticalDivider(
                thickness: 1,
                color: Colors.black.withOpacity(0.25),
              ),
              const Expanded(
                child: _AllPagesAmount(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReadPagesAmount extends StatelessWidget {
  const _ReadPagesAmount();

  @override
  Widget build(BuildContext context) {
    final int readPagesAmount = context.select(
      (BookCreatorBloc bloc) => bloc.state.readPagesAmount,
    );

    return _PagesAmount(
      label: 'Przeczytane',
      amount: readPagesAmount,
      dialogTitle: 'Podaj liczbę przeczytanych stron',
      onAmountChanged: (int amount) => _onReadPagesAmountChanged(
        amount,
        context,
      ),
    );
  }

  void _onReadPagesAmountChanged(int amount, BuildContext context) {
    context.read<BookCreatorBloc>().add(
          BookCreatorEventReadPagesAmountChanged(readPagesAmount: amount),
        );
  }
}

class _AllPagesAmount extends StatelessWidget {
  const _AllPagesAmount();

  @override
  Widget build(BuildContext context) {
    final int allPagesAmount = context.select(
      (BookCreatorBloc bloc) => bloc.state.allPagesAmount,
    );

    return _PagesAmount(
      label: 'Wszystkie',
      amount: allPagesAmount,
      dialogTitle: 'Podaj liczbę wszystkich stron',
      onAmountChanged: (int amount) => _onAllPagesAmountChanged(
        amount,
        context,
      ),
    );
  }

  void _onAllPagesAmountChanged(int amount, BuildContext context) {
    context.read<BookCreatorBloc>().add(
          BookCreatorEventAllPagesAmountChanged(allPagesAmount: amount),
        );
  }
}

class _PagesAmount extends StatelessWidget {
  final String label;
  final int amount;
  final String dialogTitle;
  final Function(int number) onAmountChanged;

  const _PagesAmount({
    required this.label,
    required this.amount,
    required this.dialogTitle,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onPressed(context),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(label),
            const SizedBox(height: 8),
            Text(
              '$amount',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    Utils.unfocusInputs();
    final int? number = await _askForNumber(context);
    if (number != null) {
      onAmountChanged(number);
    }
  }

  Future<int?> _askForNumber(BuildContext context) async {
    String? numberAsString = await context.read<DialogInterface>().askForValue(
          title: dialogTitle,
          initialValue: '$amount',
          keyboardType: TextInputType.number,
          acceptLabel: 'Zapisz',
        );
    if (numberAsString == null) {
      return null;
    }
    numberAsString = numberAsString
        .removeAllSpaces()
        .removeAllCommas()
        .removeAllDots()
        .removeAllDashes();
    if (numberAsString.isNotEmpty) {
      return int.parse(numberAsString);
    }
    return 0;
  }
}
