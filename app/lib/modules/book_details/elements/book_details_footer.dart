import 'package:app/config/themes/button_theme.dart';
import 'package:app/constants/theme.dart';
import 'package:app/core/book/book_model.dart';
import 'package:flutter/material.dart';
import 'book_details_functional_button.dart';

class BookDetailsFooter extends StatelessWidget {
  final Stream<BookStatus> bookStatus$;
  final Function onClickEditButton;
  final Function onClickFunctionalButton;

  const BookDetailsFooter({
    required this.bookStatus$,
    required this.onClickEditButton,
    required this.onClickFunctionalButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 8.0),
                  child: ElevatedButton.icon(
                    label: Text('Edytuj'),
                    icon: Icon(Icons.edit_rounded),
                    style: ButtonStyles.mediumButton(
                      color: AppColors.DARK_BLUE,
                      context: context,
                    ),
                    onPressed: () {
                      onClickEditButton();
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 16.0),
                  child: BookDetailsFunctionalButton(
                    bookStatus$: bookStatus$,
                    onClickFunctionalButton: () {
                      onClickFunctionalButton();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
