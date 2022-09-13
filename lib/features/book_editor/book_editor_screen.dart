import 'package:app/components/custom_scaffold.dart';
import 'package:flutter/widgets.dart';

class BookEditorScreen extends StatelessWidget {
  final String bookId;

  const BookEditorScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: Center(
        child: Text('book editor screen'),
      ),
    );
  }
}
