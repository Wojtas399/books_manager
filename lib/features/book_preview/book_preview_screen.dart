import 'package:app/components/custom_scaffold.dart';
import 'package:flutter/widgets.dart';

class BookPreviewScreen extends StatelessWidget {
  final String bookId;

  const BookPreviewScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Center(
        child: Text('Book $bookId preview'),
      ),
    );
  }
}
