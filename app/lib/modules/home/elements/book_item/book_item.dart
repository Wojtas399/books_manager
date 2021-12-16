import 'package:app/constants/theme.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/app_navigator_service.dart';
import 'package:app/modules/home/bloc/home_bloc.dart';
import 'package:app/modules/home/elements/book_item/book_item_controller.dart';
import 'package:app/modules/home/home_screen_dialogs.dart';
import 'package:app/widgets/icons/large_icon.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'book_item_model.dart';

class BookItem extends StatelessWidget {
  final String bookId;

  BookItem({required this.bookId});

  @override
  Widget build(BuildContext context) {
    BookItemController controller = BookItemController(
      bookId: bookId,
      bookQuery: context.read<BookQuery>(),
      homeScreenDialogs: HomeScreenDialogs(),
      navigatorService: context.read<AppNavigatorService>(),
      homeBloc: context.read<HomeBloc>(),
    );
    return StreamBuilder<BookItemModel>(
      stream: controller.bookItemData$,
      builder: (_, AsyncSnapshot<BookItemModel> snapshot) {
        BookItemModel? bookItemData = snapshot.data;
        String? title = bookItemData?.title;
        String? author = bookItemData?.author;
        int? readPages = bookItemData?.readPages;
        int? pages = bookItemData?.pages;
        String? imgUrl = bookItemData?.imgUrl;
        return Container(
          width: double.infinity,
          child: GestureDetector(
            onTap: () {
              controller.onClickBookItem(title ?? '');
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
                      child: _Image(imgUrl: imgUrl),
                    ),
                    Expanded(
                      flex: 5,
                      child: _Content(
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
      },
    );
  }
}

class _Image extends StatelessWidget {
  final String? imgUrl;

  const _Image({required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    String? url = imgUrl;
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(9),
          bottomLeft: Radius.circular(9),
        ),
        color: HexColor(AppColors.LIGHT_GREEN2),
      ),
      child: url != null
          ? ClipRRect(
              child: Image(image: NetworkImage(url), fit: BoxFit.contain),
            )
          : LargeIcon(
              icon: Icons.image,
              color: AppColors.LIGHT_GREEN,
            ),
    );
  }
}

class _Content extends StatelessWidget {
  final String? title;
  final String? author;
  final int? readPages;
  final int? pages;

  const _Content({
    required this.title,
    required this.author,
    required this.readPages,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: _BookInfo(
              title: title ?? '',
              author: author ?? '',
            ),
          ),
          Expanded(
            child: _PagesStatus(
              readPages: readPages ?? 0,
              pages: pages ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookInfo extends StatelessWidget {
  final String title;
  final String author;

  const _BookInfo({required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          author,
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PagesStatus extends StatelessWidget {
  final int readPages;
  final int pages;

  const _PagesStatus({required this.readPages, required this.pages});

  @override
  Widget build(BuildContext context) {
    double progressValue = 0;
    if (readPages > 0 && pages > 0) {
      progressValue = (readPages / (pages / 100)) / 100;
    }
    return Column(
      children: [
        Text('$readPages/$pages'),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.bottomLeft,
            widthFactor: progressValue,
            child: Container(
              decoration: BoxDecoration(
                color: HexColor(AppColors.DARK_BLUE),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
