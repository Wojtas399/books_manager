import 'package:app/components/custom_scaffold.dart';
import 'package:flutter/widgets.dart';

class BookEditorContent extends StatelessWidget {
  const BookEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: Center(
        child: Text('Content'),
      ),
    );
  }
}
