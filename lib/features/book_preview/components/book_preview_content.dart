import 'package:app/components/custom_scaffold.dart';
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
    return CustomScaffold(
      appBarTitle: 'Podgląd książki',
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: const [
                BookPreviewImage(),
                Divider(thickness: 1),
                BookPreviewDescription(),
                SizedBox(height: 24),
                BookPreviewBookStatus(),
                SizedBox(height: 12),
                BookPreviewPagesStatus(),
              ],
            ),
            const BookPreviewButton(),
          ],
        ),
      ),
    );
  }
}
