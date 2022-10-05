import 'package:app/components/custom_scaffold.dart';
import 'package:app/components/on_tap_focus_lose_area_component.dart';
import 'package:app/features/book_creator/components/book_creator_image.dart';
import 'package:app/features/book_creator/components/book_creator_pages.dart';
import 'package:app/features/book_creator/components/book_creator_submit_button.dart';
import 'package:app/features/book_creator/components/book_creator_title_author.dart';
import 'package:flutter/material.dart';

class BookCreatorContent extends StatelessWidget {
  const BookCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 24);

    return CustomScaffold(
      appBarTitle: 'Nowa książka',
      appBarWithElevation: false,
      body: SafeArea(
        child: OnTapFocusLoseAreaComponent(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: const [
                    BookCreatorImage(),
                    gap,
                    BookCreatorTitleAuthor(),
                    gap,
                    BookCreatorPages(),
                    SizedBox(height: 48),
                    BookCreatorSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
