import 'package:app/core/book/book_model.dart';
import 'package:app/modules/book_details/elements/book_details_edit/book_details_edit_model.dart';
import 'package:flutter/cupertino.dart';

class BookDetailsEditController {
  late final BookDetailsEditModel _bookDetails;
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController readPagesController;
  late TextEditingController pagesController;
  late String titleListener;

  BookDetailsEditController({
    required BookDetailsEditModel bookDetailsEditModel,
  }) {
    _bookDetails = bookDetailsEditModel;
    titleController = TextEditingController(text: bookDetailsEditModel.title);
    authorController = TextEditingController(text: bookDetailsEditModel.author);
    readPagesController =
        TextEditingController(text: '${bookDetailsEditModel.readPages}');
    pagesController =
        TextEditingController(text: '${bookDetailsEditModel.pages}');
    _setListeners();
  }

  ValueNotifier<BookCategory> selectedBookCategory =
      ValueNotifier(BookCategory.biography_autobiography);
  ValueNotifier<bool> isButtonDisabled = ValueNotifier(true);

  String? requiredValidator(String? value) {
    if (value == '') {
      return 'To pole jest wymagane';
    }
  }

  onChangeCategory(BookCategory newCategory) {
    selectedBookCategory.value = newCategory;
    _checkValues();
  }

  getEditedData() async {
    String title = titleController.text;
    String author = authorController.text;
    int readPages = int.parse(readPagesController.text);
    int pages = int.parse(pagesController.text);
    BookCategory category = selectedBookCategory.value;
    return BookDetailsEditedDataModel(
      title: title != _bookDetails.title ? title : null,
      author: author != _bookDetails.author ? author : null,
      readPages: readPages != _bookDetails.readPages ? readPages : null,
      pages: pages != _bookDetails.pages ? pages : null,
      category: category != _bookDetails.category ? category : null,
    );
  }

  removeListeners() {
    titleController.removeListener(_checkValues);
    authorController.removeListener(_checkValues);
    readPagesController.removeListener(_checkValues);
    pagesController.removeListener(_checkValues);
  }

  _setListeners() {
    titleController.addListener(_checkValues);
    authorController.addListener(_checkValues);
    readPagesController.addListener(_checkValues);
    pagesController.addListener(_checkValues);
    selectedBookCategory.value = _bookDetails.category;
  }

  _checkValues() {
    String title = titleController.text;
    String author = authorController.text;
    String readPages = readPagesController.text;
    String pages = pagesController.text;
    int convertedReadPages = readPages != '' ? int.parse(readPages) : 0;
    int convertedPages = pages != '' ? int.parse(pages) : 0;
    BookCategory category = selectedBookCategory.value;
    if ((title == _bookDetails.title &&
            author == _bookDetails.author &&
            convertedReadPages == _bookDetails.readPages &&
            convertedPages == _bookDetails.pages &&
            category == _bookDetails.category) ||
        title == '' ||
        author == '' ||
        readPages == '' ||
        pages == '') {
      isButtonDisabled.value = true;
    } else {
      isButtonDisabled.value = false;
    }
  }
}
