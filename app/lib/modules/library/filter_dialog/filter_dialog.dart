import 'package:app/config/themes/gradients.dart';
import 'package:app/constants/theme.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/library/filter_dialog/filter_dialog_controller.dart';
import 'package:app/modules/library/library_book_status_service.dart';
import 'package:app/modules/library/library_dialogs.dart';
import 'package:app/widgets/buttons/big_green_button.dart';
import 'package:app/widgets/text_fields/basic_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FilterDialog extends StatelessWidget {
  final FilterOptions filterOptions;

  const FilterDialog({required this.filterOptions});

  @override
  Widget build(BuildContext context) {
    FilterDialogController controller = FilterDialogController(
      bookCategoryService: BookCategoryService(),
      libraryScreenDialogs: LibraryDialogs(),
      filterOptions: filterOptions,
      libraryScreenBookStatusService: LibraryBookStatusService(),
    );

    return Scaffold(
      appBar: _FilterAppBar(),
      body: Container(
        padding: EdgeInsets.only(top: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Statuses(controller: controller),
              _Categories(controller: controller),
              _Pages(
                minPageController: controller.minNumberOfPagesController,
                maxPageController: controller.maxNumberOfPagesController,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: _Footer(
        onPressed: () {
          FilterOptions? options = controller.getFilterOptions();
          if (options != null) {
            Navigator.pop(context, options);
          }
        },
      ),
    );
  }
}

class _FilterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _FilterAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Opcje filtrowania',
        style: TextStyle(color: Colors.black),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Gradients.greenBlueGradient(),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 8.0),
          child: RawMaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            shape: CircleBorder(),
            constraints: BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.all(0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _Statuses extends StatelessWidget {
  final FilterDialogController controller;

  const _Statuses({required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.statuses$,
      builder: (_, AsyncSnapshot<List<CheckboxProps>> snapshot) {
        List<CheckboxProps>? statuses = snapshot.data;
        if (statuses != null) {
          return ExpansionTile(
            title: _Title(title: 'Status'),
            iconColor: Colors.black,
            collapsedIconColor: Colors.black,
            children: [
              ...statuses.map(
                (status) => _CheckboxItem(
                  title: status.name,
                  checked: status.checked,
                  onChanged: (String name, bool checked) {
                    controller.onChangeStatusCheckbox(name, checked);
                  },
                ),
              ),
            ],
          );
        }
        return Text('No data');
      },
    );
  }
}

class _Categories extends StatelessWidget {
  final FilterDialogController controller;

  const _Categories({required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.categories$,
      builder: (_, AsyncSnapshot<List<CheckboxProps>> snapshot) {
        List<CheckboxProps>? categories = snapshot.data;
        if (categories != null) {
          return ExpansionTile(
            title: _Title(title: 'Kategoria'),
            iconColor: Colors.black,
            collapsedIconColor: Colors.black,
            children: [
              ...categories.map(
                (category) => _CheckboxItem(
                  title: category.name,
                  checked: category.checked,
                  onChanged: (String name, bool checked) {
                    controller.onChangeCategoryCheckbox(name, checked);
                  },
                ),
              ),
            ],
          );
        }
        return Text('No data');
      },
    );
  }
}

class _Pages extends StatelessWidget {
  final TextEditingController minPageController;
  final TextEditingController maxPageController;

  const _Pages({
    required this.minPageController,
    required this.maxPageController,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _Title(title: 'Strony'),
      iconColor: Colors.black,
      collapsedIconColor: Colors.black,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              BasicTextFormField(
                label: 'Minimum',
                type: TextInputType.number,
                controller: minPageController,
              ),
              BasicTextFormField(
                label: 'Maksimum',
                type: TextInputType.number,
                controller: maxPageController,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckboxItem extends StatelessWidget {
  final String title;
  final bool checked;
  final Function(String name, bool val) onChanged;

  const _CheckboxItem({
    required this.title,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      value: checked,
      activeColor: HexColor(AppColors.DARK_GREEN),
      onChanged: (bool? checked) {
        if (checked != null) {
          onChanged(title, checked);
        }
      },
    );
  }
}

class _Footer extends StatelessWidget {
  final Function onPressed;

  const _Footer({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor(AppColors.LIGHT_BLUE),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                top: 8.0, right: 16.0, bottom: 16.0, left: 16.0),
            child: BigGreenButton(
              text: 'FILTRUJ',
              onPressed: () {
                onPressed();
              },
            ),
          ),
        ],
      ),
    );
  }
}
