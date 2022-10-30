import 'package:app/components/book_image_picker_component.dart';
import 'package:app/features/book_editor/bloc/book_editor_bloc.dart';
import 'package:app/models/image_file.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookEditorImage extends StatelessWidget {
  const BookEditorImage({super.key});

  @override
  Widget build(BuildContext context) {
    final ImageFile? imageFile = context.select(
      (BookEditorBloc bloc) => bloc.state.imageFile,
    );
    final ImageFile? originalImageFile = context.select(
      (BookEditorBloc bloc) => bloc.state.originalBook?.imageFile,
    );

    return BookImagePickerComponent(
      imageFile: imageFile,
      originalImageFile: originalImageFile,
      canDisplayRestoreImageAction: true,
      onImageChanged: (ImageFile? imageFile) => _onImageChanged(
        imageFile,
        context,
      ),
    );
  }

  void _onImageChanged(ImageFile? imageFile, BuildContext context) {
    context.read<BookEditorBloc>().add(
          BookEditorEventImageChanged(imageFile: imageFile),
        );
  }
}
