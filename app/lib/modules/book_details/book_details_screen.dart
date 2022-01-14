import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/modules/book_details/bloc/book_details_bloc.dart';
import 'package:app/modules/book_details/bloc/book_details_query.dart';
import 'package:app/modules/book_details/book_details_controller.dart';
import 'package:app/modules/book_details/book_details_dialogs.dart';
import 'package:app/modules/book_details/elements/book_details_app_bar.dart';
import 'package:app/modules/book_details/elements/book_details_footer.dart';
import 'package:app/modules/book_details/elements/book_details_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'book_details_model.dart';

class BookDetailsScreen extends StatelessWidget {
  final String bookId;

  const BookDetailsScreen({required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookDetailsBloc(
        bookId: bookId,
        bookQuery: context.read<BookQuery>(),
        bookBloc: context.read<BookBloc>(),
        bookCategoryService: BookCategoryService(),
      ),
      child: BlocBuilder<BookDetailsBloc, BookDetailsQuery>(
        builder: (context, query) {
          BookDetailsController controller = BookDetailsController(
            bookDetailsQuery: query,
            bookDetailsBloc: context.read<BookDetailsBloc>(),
            bookDetailsDialogs: BookDetailsDialogs(),
            imagePicker: ImagePicker(),
          );

          return Scaffold(
            appBar: BookDetailsAppBar(
              onClickDeleteButton: () {
                controller.onClickDeleteButton().listen((_) {
                  Navigator.pop(context);
                });
              },
            ),
            body: StreamBuilder(
              stream: query.bookDetails$,
              builder: (_, AsyncSnapshot<BookDetailsModel> snapshot) {
                BookDetailsModel? bookDetails = snapshot.data;
                if (bookDetails != null) {
                  return Column(
                    children: [
                      Expanded(
                        flex: 10,
                        child: _Body(bookDetails: bookDetails),
                      ),
                      Expanded(
                        child: BookDetailsFooter(
                          bookStatus$: query.status$,
                          onClickEditButton: () {
                            controller.onClickEditButton();
                          },
                          onClickFunctionalButton: () {
                            controller.onClickFunctionalButton();
                          },
                        ),
                      ),
                    ],
                  );
                }
                return Text('No book data');
              },
            ),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final BookDetailsModel bookDetails;

  const _Body({required this.bookDetails});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: _Image(imgUrl: bookDetails.imgUrl),
          ),
          BookDetailsInfo(bookDetails: bookDetails),
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String imgUrl;

  const _Image({required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor(AppColors.LIGHT_GREEN2),
      padding: EdgeInsets.all(8.0),
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: HexColor(AppColors.DARK_GREEN),
          ),
        ),
      ),
    );
  }
}
