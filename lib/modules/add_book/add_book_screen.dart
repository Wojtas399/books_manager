import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/core/services/image_service.dart';
import 'package:app/modules/add_book/add_book_controller.dart';
import 'package:app/modules/add_book/elements/add_book_app_bar.dart';
import 'package:app/modules/add_book/elements/add_book_form.dart';
import 'package:app/modules/add_book/elements/add_book_image.dart';
import 'package:app/modules/add_book/elements/add_book_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddBookController controller = AddBookController(
      imageService: ImageService(),
      bookCategoryService: BookCategoryService(),
      bookBloc: context.read<BookBloc>(),
    );

    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (context) {
          TabController? tabController = DefaultTabController.of(context);
          tabController?.addListener(() {
            _closeKeyboard(context);
          });
          return Scaffold(
            appBar: AddBookAppBar(),
            body: TabBarView(
              children: [
                AddBookForm(
                  controller: controller,
                  onClickNextButton: () {
                    if (tabController != null) {
                      tabController.animateTo(1);
                    }
                  },
                ),
                AddBookImage(
                  imgPath: controller.imgPath,
                  onClickImageButton: () {
                    controller.onClickImageButton();
                  },
                  onClickSummaryButton: () {
                    if (tabController != null) {
                      tabController.animateTo(2);
                    }
                  },
                ),
                AddBookSummary(
                  imgPath: controller.imgPath,
                  bookDetails: controller.bookDetails,
                  isButtonDisabled: controller.isSaveButtonDisabled,
                  onClickButton: () async {
                    await controller.onClickAddBookButton();
                    tabController?.removeListener(() {
                      _closeKeyboard(context);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _closeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
