import 'package:app/config/themes/text_field_theme.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/add_book/add_book_controller.dart';
import 'package:app/widgets/buttons/medium_green_button.dart';
import 'package:app/widgets/text_fields/basic_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AddBookForm extends StatelessWidget {
  final AddBookController controller;
  final Function onClickNextButton;

  const AddBookForm({
    required this.onClickNextButton,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BasicTextFormField(
                label: 'Tytuł',
                controller: controller.titleController,
                onChanged: controller.onTitleChanged,
                validator: controller.requiredValidator,
              ),
              SizedBox(height: 16.0),
              BasicTextFormField(
                label: 'Autor',
                controller: controller.authorController,
                onChanged: controller.onAuthorChanged,
                validator: controller.requiredValidator,
              ),
              SizedBox(height: 16.0),
              _CategoryTextField(
                onChanged: controller.onCategoryChanged,
              ),
              SizedBox(height: 16.0),
              BasicTextFormField(
                label: 'Liczba stron przeczytanych',
                type: TextInputType.number,
                controller: controller.readPagesController,
                onChanged: controller.onReadPagesNumberChanged,
                validator: controller.pageNumberValidator,
              ),
              SizedBox(height: 16.0),
              BasicTextFormField(
                label: 'Liczba wszystkich stron',
                type: TextInputType.number,
                controller: controller.pagesController,
                onChanged: controller.onPagesNumberChanged,
                validator: controller.pageNumberValidator,
              ),
              SizedBox(height: 8.0),
              _GlobalFormError(errorMessage: controller.globalFormErrorMessage),
              SizedBox(height: 8.0),
              _Button(
                isDisabled: controller.isNextButtonDisabled,
                onClick: () {
                  onClickNextButton();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTextField extends StatelessWidget {
  final Function(BookCategory category) onChanged;

  const _CategoryTextField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final BookCategoryService _bookCategoryService = BookCategoryService();

    return DropdownButtonFormField(
      isExpanded: true,
      decoration: TextFieldTheme.basicTheme(
        label: 'Kategoria',
      ),
      value: BookCategory.biography_autobiography,
      items: BookCategory.values
          .map(
            (value) => DropdownMenuItem(
              value: value,
              child: Text(_bookCategoryService.convertCategoryToText(value)),
            ),
          )
          .toList(),
      onChanged: (category) {
        onChanged(category as BookCategory);
      },
    );
  }
}

class _GlobalFormError extends StatelessWidget {
  final ValueNotifier<String> errorMessage;

  const _GlobalFormError({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: errorMessage,
      builder: (_, String message, child) {
        return Text(
          message,
          style: TextStyle(color: HexColor('#D34545')),
        );
      },
    );
  }
}

class _Button extends StatelessWidget {
  final Function onClick;
  final ValueNotifier<bool> isDisabled;

  const _Button({required this.onClick, required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDisabled,
      builder: (_, bool disabled, child) {
        return Row(
          children: [
            Expanded(
              child: MediumGreenButton(
                text: 'Dalej',
                onPressed: disabled == true
                    ? null
                    : () {
                        onClick();
                      },
              ),
            ),
          ],
        );
      },
    );
  }
}
