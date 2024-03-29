import 'package:app/components/custom_scaffold_component.dart';
import 'package:app/features/book_preview/components/book_preview_actions_icon.dart';
import 'package:app/features/book_preview/components/book_preview_book_status.dart';
import 'package:app/features/book_preview/components/book_preview_button.dart';
import 'package:app/features/book_preview/components/book_preview_description.dart';
import 'package:app/features/book_preview/components/book_preview_image.dart';
import 'package:app/features/book_preview/components/book_preview_pages_status.dart';
import 'package:flutter/material.dart';

class BookPreviewContent extends StatelessWidget {
  const BookPreviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      resizeToAvoidBottomInset: false,
      appBarTitle: 'Podgląd książki',
      trailing: BookPreviewActionsIcon(),
      trailingRightPadding: 0,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  BookPreviewImage(),
                  Divider(thickness: 1),
                  BookPreviewDescription(),
                  SizedBox(height: 24),
                  BookPreviewBookStatus(),
                  SizedBox(height: 12),
                  BookPreviewPagesStatus(),
                ],
              ),
              BookPreviewButton(),
            ],
          ),
        ),
      ),
    );
  }
}
