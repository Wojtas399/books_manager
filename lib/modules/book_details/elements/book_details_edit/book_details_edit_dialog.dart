import 'package:app/config/themes/text_field_theme.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_controller.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_model.dart';
import 'package:app/widgets/app_bars/dialog_app_bar.dart';
import 'package:app/widgets/buttons/medium_green_button.dart';
import 'package:app/widgets/buttons/medium_red_button.dart';
import 'package:app/widgets/text_fields/basic_text_form_field.dart';
import 'package:flutter/material.dart';

class BookDetailsEditDialog extends StatelessWidget {
  final BookDetailsEditModel bookDetails;

  BookDetailsEditDialog({required this.bookDetails});

  @override
  Widget build(BuildContext context) {
    BookDetailsEditController controller = BookDetailsEditController(
      bookDetailsEditModel: bookDetails,
    );

    return Scaffold(
      appBar: DialogAppBar(title: 'Edytuj dane'),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _DetailsTextFields(controller: controller),
              _Buttons(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsTextFields extends StatelessWidget {
  final BookDetailsEditController controller;

  const _DetailsTextFields({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          BasicTextFormField(
            label: 'Tytuł',
            controller: controller.titleController,
            validator: controller.requiredValidator,
          ),
          SizedBox(height: 16.0),
          BasicTextFormField(
            label: 'Autor',
            controller: controller.authorController,
            validator: controller.requiredValidator,
          ),
          SizedBox(height: 16.0),
          _CategorySelectInput(
            selectedBookCategory: controller.selectedBookCategory,
            onChanged: (BookCategory category) {
              controller.onChangeCategory(category);
            },
          ),
          SizedBox(height: 16.0),
          BasicTextFormField(
            label: 'Przeczytane strony',
            controller: controller.readPagesController,
            type: TextInputType.number,
            validator: controller.requiredValidator,
          ),
          SizedBox(height: 16.0),
          BasicTextFormField(
            label: 'Strony',
            controller: controller.pagesController,
            type: TextInputType.number,
            validator: controller.requiredValidator,
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class _CategorySelectInput extends StatelessWidget {
  final ValueNotifier selectedBookCategory;
  final Function(BookCategory category) onChanged;

  const _CategorySelectInput({
    required this.selectedBookCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    BookCategoryService bookCategoryService = BookCategoryService();

    return ValueListenableBuilder(
      valueListenable: selectedBookCategory,
      builder: (_, selectedCategory, child) {
        return Container(
          width: double.infinity,
          child: DropdownButtonFormField(
            isExpanded: true,
            decoration: TextFieldTheme.basicTheme(
              label: 'Kategoria',
            ),
            value: selectedCategory,
            items: BookCategory.values
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child:
                        Text(bookCategoryService.convertCategoryToText(value)),
                  ),
                )
                .toList(),
            onChanged: (category) {
              onChanged(category as BookCategory);
            },
          ),
        );
      },
    );
  }
}

class _Buttons extends StatelessWidget {
  final BookDetailsEditController controller;

  const _Buttons({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.isButtonDisabled,
      builder: (_, bool isDisabled, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 8.0),
                child: MediumRedButton(
                  text: 'Anuluj',
                  icon: Icons.close,
                  onPressed: () {
                    Navigator.pop(context);
                    controller.removeListeners();
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0, right: 16.0),
                child: MediumGreenButton(
                  text: 'Zapisz',
                  icon: Icons.check,
                  onPressed: isDisabled
                      ? null
                      : () {
                          Navigator.pop(context, controller.getEditedData());
                          controller.removeListeners();
                        },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
