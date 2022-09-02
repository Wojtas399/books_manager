import 'package:flutter/material.dart';

import '../../../components/custom_scaffold.dart';
import '../../../components/on_tap_focus_lose_area_component.dart';
import 'book_creator_image.dart';
import 'book_creator_pages.dart';
import 'book_creator_submit_button.dart';
import 'book_creator_title_author.dart';

class BookCreatorContent extends StatelessWidget {
  const BookCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Nowa książka',
      appBarWithElevation: false,
      body: SingleChildScrollView(
        child: OnTapFocusLoseAreaComponent(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: const [
                BookCreatorImage(),
                SizedBox(height: 24),
                BookCreatorTitleAuthor(),
                SizedBox(height: 24),
                BookCreatorPages(),
                SizedBox(height: 24),
                BookCreatorSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
