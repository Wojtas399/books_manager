import 'package:flutter/material.dart';
import '../book_details_model.dart';

class BookDetailsInfo extends StatelessWidget {
  final BookDetailsModel bookDetails;

  const BookDetailsInfo({required this.bookDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookDetails.title,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 4),
          Text(
            bookDetails.author,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 16),
          _InfoItem(keyName: 'Kategoria', value: bookDetails.category),
          SizedBox(height: 8),
          _InfoItem(
            keyName: 'Stan stron',
            value: '${bookDetails.readPages}/${bookDetails.pages}',
          ),
          SizedBox(height: 8),
          _InfoItem(keyName: 'Status', value: bookDetails.status),
          SizedBox(height: 8),
          _InfoItem(
            keyName: 'Data ostatniej aktualizacji',
            value: bookDetails.lastActualisation,
          ),
          SizedBox(height: 8),
          _InfoItem(keyName: 'Data dodadania', value: bookDetails.addDate),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String keyName;
  final String value;

  const _InfoItem({required this.keyName, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(keyName, style: Theme.of(context).textTheme.bodyText1),
        SizedBox(height: 2),
        Text(value, style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }
}
