import 'dart:typed_data';

import 'package:app/features/book_creator/bloc/book_creator_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookCreatorImage extends StatelessWidget {
  const BookCreatorImage({super.key});

  @override
  Widget build(BuildContext context) {
    final Uint8List? imageData = context.select(
      (BookCreatorBloc bloc) => bloc.state.imageData,
    );

    return const SizedBox();
    // return BookImagePickerComponent(
    //   imageData: imageData,
    //   onImageDataChanged: (Uint8List? imageData) => _onImageChanged(
    //     imageData,
    //     context,
    //   ),
    // );
  }

  void _onImageChanged(Uint8List? imageData, BuildContext context) {
    context.read<BookCreatorBloc>().add(
          BookCreatorEventChangeImage(imageData: imageData),
        );
  }
}
