import 'dart:typed_data';

import 'package:app/features/book_editor/bloc/book_editor_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookEditorImage extends StatelessWidget {
  const BookEditorImage({super.key});

  @override
  Widget build(BuildContext context) {
    final Uint8List? imageData = context.select(
      (BookEditorBloc bloc) => bloc.state.imageData,
    );
    final Uint8List? originalImageData = context.select(
      (BookEditorBloc bloc) => bloc.state.originalBook?.imageData,
    );

    return const SizedBox();
    // return BookImagePickerComponent(
    //   imageData: imageData,
    //   originalImageData: originalImageData,
    //   canDisplayRestoreImageAction: true,
    //   onImageDataChanged: (Uint8List? imageData) => _onImageChanged(
    //     imageData,
    //     context,
    //   ),
    // );
  }

  void _onImageChanged(Uint8List? imageData, BuildContext context) {
    context.read<BookEditorBloc>().add(
          BookEditorEventImageChanged(imageData: imageData),
        );
  }
}
