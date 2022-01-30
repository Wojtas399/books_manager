import 'package:app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class BookItemContent extends StatelessWidget {
  final String title;
  final String author;
  final int readPages;
  final int pages;

  const BookItemContent({
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
            child: _BookInfo(title: title, author: author),
          ),
          Expanded(
            child: _PagesStatus(readPages: readPages, pages: pages),
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
