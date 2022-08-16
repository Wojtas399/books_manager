import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/core/services/image_service.dart';
import 'package:app/modules/add_book/add_book_model.dart';
import 'package:flutter/material.dart';

class AddBookController {
  late final ImageService _imageService;
  late final BookCategoryService _bookCategoryService;
  late final BookBloc _bookBloc;

  TextEditingController titleController = TextEditingController(text: '');
  TextEditingController authorController = TextEditingController(text: '');
  TextEditingController readPagesController = TextEditingController(text: '');
  TextEditingController pagesController = TextEditingController(text: '');
  ValueNotifier<String?> imgPath = ValueNotifier<String?>(null);
  ValueNotifier<AddBookFormModel> bookDetails = ValueNotifier(
    AddBookFormModel(
      title: '',
      author: '',
      category: 'biografie i autobiografie',
      readPages: 0,
      pages: 0,
    ),
  );
  ValueNotifier<String> globalFormErrorMessage = ValueNotifier<String>('');
  ValueNotifier<bool> isNextButtonDisabled = ValueNotifier<bool>(true);
  ValueNotifier<bool> isSaveButtonDisabled = ValueNotifier<bool>(true);

  AddBookController({
    required ImageService imageService,
    required BookCategoryService bookCategoryService,
    required BookBloc bookBloc,
  }) {
    _imageService = imageService;
    _bookCategoryService = bookCategoryService;
    _bookBloc = bookBloc;
    bookDetails.addListener(_setButtonsDisableProps);
  }

  String? requiredValidator(String? value) {
    if (value == '') {
      return 'To pole jest wymagane';
    }
  }

  String? pageNumberValidator(String? value) {
    if (value == '') {
      return null;
    } else if (value != null && !_isGoodPageNumber(value)) {
      return 'Podano niepoprawną liczbę';
    }
  }

  onClickImageButton() async {
    String? newImgPath = await _imageService.getImageFromGallery();
    if (newImgPath != null) {
      imgPath.value = newImgPath;
    }
    isSaveButtonDisabled.value = !_areGoodFormValuesAndImage();
  }

  onTitleChanged(String? value) {
    if (value != null) {
      _setNewDetailValue(title: value);
    }
  }

  onAuthorChanged(String? value) {
    if (value != null) {
      _setNewDetailValue(author: value);
    }
  }

  onCategoryChanged(BookCategory category) {
    _setNewDetailValue(
      category: _bookCategoryService.convertCategoryToText(category),
    );
  }

  onReadPagesNumberChanged(String? value) {
    if (value != null) {
      _setNewDetailValue(
        readPages: _isGoodPageNumber(value) ? int.parse(value) : 0,
      );
      _setPagesError();
    }
  }

  onPagesNumberChanged(String? value) {
    if (value != null) {
      _setNewDetailValue(
        pages: _isGoodPageNumber(value) ? int.parse(value) : 0,
      );
      _setPagesError();
    }
  }

  onClickAddBookButton() async {
    String? imgPathValue = imgPath.value;
    if (imgPathValue != null) {
      await _bookBloc.addNewBook(
        title: bookDetails.value.title,
        author: bookDetails.value.author,
        category: _bookCategoryService.convertTextToCategory(
          bookDetails.value.category,
        ),
        imgPath: imgPathValue,
        readPages: bookDetails.value.readPages,
        pages: bookDetails.value.pages,
        status: BookStatus.pending,
      );
      bookDetails.removeListener(_setButtonsDisableProps);
    }
  }

  bool _isGoodPageNumber(String value) {
    return int.tryParse(value) != null && int.parse(value) >= 0;
  }

  bool _areGoodPagesValues() {
    return bookDetails.value.readPages < bookDetails.value.pages;
  }

  bool _areGoodFormValues() {
    return bookDetails.value.title != '' &&
        bookDetails.value.author != '' &&
        _isGoodPageNumber(readPagesController.text) &&
        _isGoodPageNumber(pagesController.text) &&
        _areGoodPagesValues();
  }

  bool _areGoodFormValuesAndImage() {
    return _areGoodFormValues() && imgPath.value != null;
  }

  _setNewDetailValue({
    String? title,
    String? author,
    String? category,
    int? readPages,
    int? pages,
  }) {
    bookDetails.value = AddBookFormModel(
      title: title != null ? title : bookDetails.value.title,
      author: author != null ? author : bookDetails.value.author,
      category: category != null ? category : bookDetails.value.category,
      readPages: readPages != null ? readPages : bookDetails.value.readPages,
      pages: pages != null ? pages : bookDetails.value.pages,
    );
  }

  _setButtonsDisableProps() {
    isNextButtonDisabled.value = !_areGoodFormValues();
    isSaveButtonDisabled.value = !_areGoodFormValuesAndImage();
  }

  _setPagesError() {
    if (_areGoodPagesValues()) {
      globalFormErrorMessage.value = '';
    } else if (pagesController.text != '') {
      globalFormErrorMessage.value =
          'Liczba stron przeczytanych musi być mniejsza od liczby wszystkich stron książki';
    }
  }
}
