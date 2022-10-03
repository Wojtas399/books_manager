import 'package:app/domain/entities/read_book.dart';
import 'package:flutter/material.dart';

class DayPreviewDialog extends StatelessWidget {
  final List<ReadBook> readBooks;

  const DayPreviewDialog({super.key, required this.readBooks});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Center(
        child: Text('Day preview dialog'),
      ),
    );
  }
}
