import 'package:app/components/book_image_picker_component.dart';
import 'package:app/features/book_editor/bloc/book_editor_bloc.dart';
import 'package:app/models/image.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_bloc/flutter_bloc.dart';

class BookEditorImage extends widgets.StatelessWidget {
  const BookEditorImage({super.key});

  @override
  widgets.Widget build(widgets.BuildContext context) {
    final Image? image = context.select(
      (BookEditorBloc bloc) => bloc.state.image,
    );
    final Image? originalImageFile = context.select(
      (BookEditorBloc bloc) => bloc.state.originalBook?.image,
    );

    return BookImagePickerComponent(
      image: image,
      originalImage: originalImageFile,
      canDisplayRestoreImageAction: true,
      onImageChanged: (Image? image) => _onImageChanged(image, context),
    );
  }

  void _onImageChanged(Image? image, widgets.BuildContext context) {
    context.read<BookEditorBloc>().add(
          BookEditorEventImageChanged(image: image),
        );
  }
}
