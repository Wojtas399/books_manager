import 'package:app/domain/interfaces/dialog_interface.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookPagesEditorComponent extends StatelessWidget {
  final int readPagesAmount;
  final int allPagesAmount;
  final Function(int amount)? onReadPagesAmountChanged;
  final Function(int amount)? onAllPagesAmountChanged;

  const BookPagesEditorComponent({
    super.key,
    this.readPagesAmount = 0,
    this.allPagesAmount = 0,
    this.onReadPagesAmountChanged,
    this.onAllPagesAmountChanged,
  });

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
              Expanded(
                child: _ReadPagesAmount(
                  amount: readPagesAmount,
                  onChanged: onReadPagesAmountChanged,
                ),
              ),
              const VerticalDivider(thickness: 1),
              Expanded(
                child: _AllPagesAmount(
                  amount: allPagesAmount,
                  onChanged: onAllPagesAmountChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReadPagesAmount extends StatelessWidget {
  final int amount;
  final Function(int amount)? onChanged;

  const _ReadPagesAmount({required this.amount, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _PagesAmount(
      label: 'Przeczytane',
      amount: amount,
      dialogTitle: 'Podaj liczbę przeczytanych stron',
      onAmountChanged: _onAmountChanged,
    );
  }

  void _onAmountChanged(int amount) {
    final Function(int amount)? onChanged = this.onChanged;
    if (onChanged != null) {
      onChanged(amount);
    }
  }
}

class _AllPagesAmount extends StatelessWidget {
  final int amount;
  final Function(int amount)? onChanged;

  const _AllPagesAmount({required this.amount, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _PagesAmount(
      label: 'Wszystkie',
      amount: amount,
      dialogTitle: 'Podaj liczbę wszystkich stron',
      onAmountChanged: _onAmountChanged,
    );
  }

  void _onAmountChanged(int amount) {
    final Function(int amount)? onChanged = this.onChanged;
    if (onChanged != null) {
      onChanged(amount);
    }
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
    return numberAsString?.toInt();
  }
}
