import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/custom_button_component.dart';
import '../bloc/book_creator_bloc.dart';

class BookCreatorSubmitButton extends StatelessWidget {
  const BookCreatorSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (BookCreatorBloc bloc) => bloc.state.isButtonDisabled,
    );

    return CustomButton(
      label: 'Dodaj',
      onPressed: isDisabled ? null : () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<BookCreatorBloc>().add(
          const BookCreatorEventSubmit(),
        );
  }
}
