import 'package:app/constants/theme.dart';
import 'package:app/modules/home/bloc/home_bloc.dart';
import 'package:app/modules/home/bloc/home_query.dart';
import 'package:app/modules/home/elements/book_item/book_item_content.dart';
import 'package:app/modules/home/elements/book_item/book_item_controller.dart';
import 'package:app/modules/home/home_screen_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'book_item_image.dart';

class BookItem extends StatelessWidget {
  final String bookId;

  BookItem({required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeQuery>(
      builder: (context, query) {
        BookItemController controller = BookItemController(
          bookId: bookId,
          homeQuery: query,
          homeBloc: context.read<HomeBloc>(),
          homeScreenDialogs: HomeScreenDialogs(),
        );
        return StreamBuilder<BookItemDetails>(
          stream: controller.bookItemDetails$,
          builder: (_, AsyncSnapshot<BookItemDetails> snapshot) {
            BookItemDetails? bookItemData = snapshot.data;
            String? title = bookItemData?.title;
            String? author = bookItemData?.author;
            int? readPages = bookItemData?.readPages;
            int? pages = bookItemData?.pages;
            String? imgUrl = bookItemData?.imgUrl;
            return _BookItem(
              title: title ?? '',
              author: author ?? '',
              pages: pages ?? 0,
              readPages: readPages ?? 0,
              imgUrl: imgUrl,
              onTap: () {
                controller.onClickBookItem();
              },
            );
          },
        );
      },
    );
  }
}

class _BookItem extends StatelessWidget {
  final String title;
  final String author;
  final int pages;
  final int readPages;
  final String? imgUrl;
  final Function onTap;

  const _BookItem({
    required this.title,
    required this.author,
    required this.pages,
    required this.readPages,
    required this.imgUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          color: HexColor(AppColors.LIGHT_GREEN),
          child: Container(
            height: 125,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: BookItemImage(imgUrl: imgUrl),
                ),
                Expanded(
                  flex: 5,
                  child: BookItemContent(
                    title: title,
                    author: author,
                    readPages: readPages,
                    pages: pages,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
