import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/library/library_book_status_service.dart';
import 'package:app/modules/library/library_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class FilterDialogController {
  late BookCategoryService _bookCategoryService;
  late LibraryDialogs _dialogs;
  late FilterOptions _filterOptions;
  late LibraryBookStatusService _bookStatusService;
  BehaviorSubject<List<CheckboxProps>> _statuses =
      new BehaviorSubject<List<CheckboxProps>>.seeded([]);
  BehaviorSubject<List<CheckboxProps>> _categories =
      new BehaviorSubject<List<CheckboxProps>>.seeded([]);
  TextEditingController minNumberOfPagesController =
      TextEditingController(text: '');
  TextEditingController maxNumberOfPagesController =
      TextEditingController(text: '');

  FilterDialogController({
    required BookCategoryService bookCategoryService,
    required LibraryDialogs libraryScreenDialogs,
    required FilterOptions filterOptions,
    required LibraryBookStatusService libraryScreenBookStatusService,
  }) {
    _bookCategoryService = bookCategoryService;
    _dialogs = libraryScreenDialogs;
    _filterOptions = filterOptions;
    _bookStatusService = libraryScreenBookStatusService;
    _setStatuses();
    _setCategories();
    _setMinNumberOfPages();
    _setMaxNumberOfPages();
  }

  Stream<List<CheckboxProps>> get statuses$ => _statuses.stream;

  Stream<List<CheckboxProps>> get categories$ => _categories.stream;

  onChangeStatusCheckbox(String name, bool checked) {
    List<CheckboxProps> statuses = _statuses.value;
    int idx = statuses.indexWhere((status) => status.name == name);
    statuses[idx].checked = checked;
    _statuses.add(statuses);
  }

  onChangeCategoryCheckbox(String name, bool checked) {
    List<CheckboxProps> categories = _categories.value;
    int idx = categories.indexWhere((category) => category.name == name);
    categories[idx].checked = checked;
    _categories.add(categories);
  }

  FilterOptions? getFilterOptions() {
    List<BookStatus> statuses = _getCheckedStatuses();
    List<BookCategory> categories = _getCheckedCategories();
    int minNumberOfPages = _getMinNumberOfPages();
    int maxNumberOfPages = _getMaxNumberOfPages();
    if ((minNumberOfPages > 0 &&
            maxNumberOfPages > 0 &&
            minNumberOfPages >= maxNumberOfPages) ||
        minNumberOfPages < 0 ||
        maxNumberOfPages < 0) {
      _dialogs.showWrongPagesInfo();
    } else {
      return FilterOptions(
        statuses: statuses.length == 0 ? null : statuses,
        categories: categories.length == 0 ? null : categories,
        minNumberOfPages: minNumberOfPages == 0 ? null : minNumberOfPages,
        maxNumberOfPages: maxNumberOfPages == 0 ? null : maxNumberOfPages,
      );
    }
  }

  _setStatuses() {
    List<BookStatus>? statuses = _filterOptions.statuses;
    List<String> statusesNames = [
      'czytane',
      'przeczytane',
      'nieprzeczytane',
      'wstrzymane',
    ];
    _statuses.add(
      statusesNames
          .map((statusName) => CheckboxProps(
                name: statusName,
                checked: statuses != null
                    ? statuses.contains(_bookStatusService
                        .convertBookStatusStringToEnum(statusName))
                    : false,
              ))
          .toList(),
    );
  }

  _setCategories() {
    List<BookCategory>? categories = _filterOptions.categories;
    _categories.add(
      BookCategory.values
          .map((category) => CheckboxProps(
                name: _bookCategoryService.convertCategoryToText(category),
                checked:
                    categories != null ? categories.contains(category) : false,
              ))
          .toList(),
    );
  }

  _setMinNumberOfPages() {
    int? minNumberOfPages = _filterOptions.minNumberOfPages;
    if (minNumberOfPages != null) {
      minNumberOfPagesController.text = '$minNumberOfPages';
    }
  }

  _setMaxNumberOfPages() {
    int? maxNumberOfPages = _filterOptions.maxNumberOfPages;
    if (maxNumberOfPages != null) {
      maxNumberOfPagesController.text = '$maxNumberOfPages';
    }
  }

  List<BookStatus> _getCheckedStatuses() {
    return _statuses.value
        .where((status) => status.checked)
        .map((status) =>
            _bookStatusService.convertBookStatusStringToEnum(status.name))
        .toList();
  }

  List<BookCategory> _getCheckedCategories() {
    return _categories.value
        .where((category) => category.checked)
        .map((category) => _bookCategoryService.convertTextToCategory(
              category.name,
            ))
        .toList();
  }

  int _getMinNumberOfPages() {
    if (minNumberOfPagesController.text != '') {
      return int.parse(minNumberOfPagesController.text);
    }
    return 0;
  }

  int _getMaxNumberOfPages() {
    if (maxNumberOfPagesController.text != '') {
      return int.parse(maxNumberOfPagesController.text);
    }
    return 0;
  }
}

class CheckboxProps {
  final String name;
  bool checked;

  CheckboxProps({required this.name, required this.checked});
}

class FilterOptions {
  List<BookStatus>? statuses;
  List<BookCategory>? categories;
  int? minNumberOfPages;
  int? maxNumberOfPages;

  FilterOptions({
    this.statuses,
    this.categories,
    this.minNumberOfPages,
    this.maxNumberOfPages,
  });

  @override
  bool operator ==(Object other) =>
      other is FilterOptions &&
      other.runtimeType == runtimeType &&
      other.statuses == statuses &&
      other.categories == categories &&
      other.minNumberOfPages == minNumberOfPages &&
      other.maxNumberOfPages == maxNumberOfPages;

  @override
  int get hashCode => statuses.hashCode;
}
