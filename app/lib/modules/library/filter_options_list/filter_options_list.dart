import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/library/filter_dialog/filter_dialog_controller.dart';
import 'package:flutter/material.dart';
import '../library_screen_book_status_service.dart';
import '../library_screen_controller.dart';
import 'filter_option_item.dart';

class FilterOptionsList extends StatelessWidget {
  final LibraryScreenController controller;

  const FilterOptionsList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.filterOptions$,
      builder: (_, AsyncSnapshot<FilterOptions> snapshot) {
        FilterOptions? options = snapshot.data;
        if (options != null) {
          int? minNumberOfPages = options.minNumberOfPages;
          int? maxNumberOfPages = options.maxNumberOfPages;
          return Container(
            margin: EdgeInsets.only(top: 62.0),
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _StatusesList(
                  statuses: options.statuses,
                  onClickDelete: controller.onDeleteStatus,
                ),
                _CategoriesList(
                  categories: options.categories,
                  onClickDelete: controller.onDeleteCategory,
                ),
                _NumberOfPages(
                  name: 'min. liczba stron',
                  numberOfPages: minNumberOfPages,
                  onClickDelete: () {
                    controller.onDeleteMinNumberOfPages();
                  },
                ),
                _NumberOfPages(
                  name: 'max. liczba stron',
                  numberOfPages: maxNumberOfPages,
                  onClickDelete: () {
                    controller.onDeleteMaxNumberOfPages();
                  },
                ),
              ],
            ),
          );
        }
        return Text('');
      },
    );
  }
}

class _StatusesList extends StatelessWidget {
  final List<BookStatus>? statuses;
  final Function(BookStatus status) onClickDelete;

  const _StatusesList({required this.statuses, required this.onClickDelete});

  @override
  Widget build(BuildContext context) {
    LibraryScreenBookStatusService bookStatusService =
        LibraryScreenBookStatusService();

    return Row(
      children: [
        ...?statuses
            ?.map((status) => FilterOptionItem(
                  sectionName: 'status',
                  filterName:
                      bookStatusService.convertBookStatusEnumToString(status),
                  onClickDelete: () {
                    onClickDelete(status);
                  },
                ))
            .toList(),
      ],
    );
  }
}

class _CategoriesList extends StatelessWidget {
  final List<BookCategory>? categories;
  final Function(BookCategory category) onClickDelete;

  const _CategoriesList({
    required this.categories,
    required this.onClickDelete,
  });

  @override
  Widget build(BuildContext context) {
    BookCategoryService bookCategoryService = BookCategoryService();

    return Row(
      children: [
        ...?categories
            ?.map((category) => FilterOptionItem(
                  sectionName: 'kategoria',
                  filterName:
                      bookCategoryService.convertCategoryToText(category),
                  onClickDelete: () {
                    onClickDelete(category);
                  },
                ))
            .toList(),
      ],
    );
  }
}

class _NumberOfPages extends StatelessWidget {
  final String name;
  final int? numberOfPages;
  final Function onClickDelete;

  const _NumberOfPages({
    required this.name,
    required this.numberOfPages,
    required this.onClickDelete,
  });

  @override
  Widget build(BuildContext context) {
    return numberOfPages != null
        ? FilterOptionItem(
            sectionName: name,
            filterName: '$numberOfPages',
            onClickDelete: () {
              onClickDelete();
            },
          )
        : Text('');
  }
}
