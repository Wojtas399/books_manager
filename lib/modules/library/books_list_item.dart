import 'package:app/constants/route_paths/app_route_path.dart';
import 'package:app/constants/theme.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/app_navigator_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class BooksListItem extends StatelessWidget {
  final String bookId;

  const BooksListItem({required this.bookId});

  @override
  Widget build(BuildContext context) {
    BookQuery bookQuery = Provider.of<BookQuery>(context);
    AppNavigatorService appNavigatorService =
        Provider.of<AppNavigatorService>(context);

    return Container(
        margin: EdgeInsets.all(1.0),
        width: 120,
        height: 150,
        child: GestureDetector(
          onTap: () {
            appNavigatorService.pushNamed(
              path: AppRoutePath.BOOK_DETAILS,
              arguments: {
                'bookId': bookId,
              },
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            color: HexColor(AppColors.LIGHT_GREEN2),
            child: StreamBuilder(
              stream: bookQuery.selectImgUrl(bookId),
              builder: (_, AsyncSnapshot<String> snapshot) {
                String? url = snapshot.data;
                if (url != null) {
                  return _Image(imgUrl: url);
                }
                return Text('');
              },
            ),
          ),
        ));
  }
}

class _Image extends StatelessWidget {
  final String imgUrl;

  const _Image({required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    Image(image: CachedNetworkImageProvider(imgUrl));
    return Container(
      height: double.infinity,
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
