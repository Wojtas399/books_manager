import 'package:flutter/widgets.dart';

import '../../components/custom_scaffold.dart';

class BookCreatorScreen extends StatelessWidget {
  const BookCreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: Center(
        child: Text('Book creator screen'),
      ),
    );
  }
}
