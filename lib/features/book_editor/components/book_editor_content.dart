import 'package:app/components/custom_scaffold.dart';
import 'package:app/components/on_tap_focus_lose_area_component.dart';
import 'package:app/features/book_editor/components/book_editor_image.dart';
import 'package:app/features/book_editor/components/book_editor_pages.dart';
import 'package:app/features/book_editor/components/book_editor_title_author.dart';
import 'package:flutter/widgets.dart';

class BookEditorContent extends StatelessWidget {
  const BookEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 24);

    return CustomScaffold(
      appBarTitle: 'Edytor książki',
      appBarWithElevation: false,
      body: SingleChildScrollView(
        child: OnTapFocusLoseAreaComponent(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: const [
                BookEditorImage(),
                gap,
                BookEditorTitleAuthor(),
                gap,
                BookEditorPages(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
