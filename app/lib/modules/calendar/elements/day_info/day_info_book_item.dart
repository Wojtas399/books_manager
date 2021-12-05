import 'package:app/modules/calendar/elements/day_info/day_info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayInfoBookItem extends StatelessWidget {
  final DayBookInfo bookInfo;

  const DayInfoBookItem({required this.bookInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Title(title: bookInfo.title),
                  _ReadPages(amount: bookInfo.readPages),
                ],
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tytuł:', style: Theme.of(context).textTheme.caption),
        SizedBox(height: 4),
        Container(
          width: 280,
          child: Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}

class _ReadPages extends StatelessWidget {
  final int amount;

  const _ReadPages({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Ilość stron:',
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(height: 4),
        Text('$amount', style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }
}
