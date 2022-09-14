import 'package:app/components/custom_button.dart';
import 'package:app/features/book_editor/bloc/book_editor_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookEditorSubmitButton extends StatelessWidget {
  const BookEditorSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (BookEditorBloc bloc) => bloc.state.isButtonDisabled,
    );

    return CustomButton(
      label: 'Zapisz',
      onPressed: isDisabled ? null : () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<BookEditorBloc>().add(
          const BookEditorEventSubmit(),
        );
  }
}
